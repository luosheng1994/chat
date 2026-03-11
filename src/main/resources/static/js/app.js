const state = { users: [], currentUserId: 1, session: null, sessionType: null, stomp: null };

const el = {
  currentUser: document.getElementById('currentUser'), friendList: document.getElementById('friendList'), groupList: document.getElementById('groupList'),
  chatTitle: document.getElementById('chatTitle'), msgArea: document.getElementById('msgArea'), input: document.getElementById('input'),
  sendBtn: document.getElementById('sendBtn'), emojiBtn: document.getElementById('emojiBtn'), plusBtn: document.getElementById('plusBtn'),
  emojiPanel: document.getElementById('emojiPanel'), plusPanel: document.getElementById('plusPanel'), fileInput: document.getElementById('fileInput'),
  voiceBtn: document.getElementById('voiceBtn'), newGroupBtn: document.getElementById('newGroupBtn'), renameBtn: document.getElementById('renameBtn')
};

async function api(url, opt = {}) {
  const res = await fetch(url, { headers: { 'Content-Type': 'application/json' }, ...opt });
  if (!res.ok) throw new Error(await res.text());
  if (res.status === 204) return {};
  const text = await res.text();
  return text ? JSON.parse(text) : {};
}

function renderUsers() {
  el.currentUser.innerHTML = state.users.map(u => `<option value="${u.id}">${u.nickname}</option>`).join('');
  el.currentUser.value = String(state.currentUserId);
}

async function loadContacts() {
  const friends = await api(`/api/friends/${state.currentUserId}`);
  const usersById = Object.fromEntries(state.users.map(u => [u.id, u]));
  el.friendList.innerHTML = friends.map(f => `<li data-id="${f.friendId}" data-type="private"><span>${f.remark || usersById[f.friendId]?.nickname || ('用户'+f.friendId)}</span><button data-remark="${f.friendId}">备注</button></li>`).join('');
  const groups = await api(`/api/groups/${state.currentUserId}`);
  el.groupList.innerHTML = groups.map(g => `<li data-id="${g.id}" data-type="group">${g.name}</li>`).join('');
}

function addMessage(m) {
  const self = m.senderId === state.currentUserId;
  const cls = m.type === 'SYSTEM' ? 'system' : self ? 'self' : 'other';
  const c = m.recalled ? '<span class="recall">消息已撤回</span>' : m.type === 'FILE' ? `<a href="${m.content}" download="${m.fileName}">📎 ${m.fileName}</a>` : m.type === 'VOICE' ? `<audio controls src="${m.content}"></audio>` : m.content;
  const recallBtn = self && !m.recalled && m.type !== 'SYSTEM' ? `<button data-recall="${m.id}">撤回</button>` : '';
  el.msgArea.insertAdjacentHTML('beforeend', `<div class="msg ${cls}" data-mid="${m.id}">${c}${recallBtn}</div>`);
  el.msgArea.scrollTop = el.msgArea.scrollHeight;
}

async function loadHistory() {
  el.msgArea.innerHTML = '';
  let data = [];
  if (state.sessionType === 'private') data = await api(`/api/history/private?a=${state.currentUserId}&b=${state.session}`);
  if (state.sessionType === 'group') data = await api(`/api/history/group/${state.session}`);
  data.forEach(addMessage);
}

async function sendText(content, type='TEXT', fileName='') {
  if (!state.session) return alert('请先选择会话');
  const payload = { senderId: state.currentUserId, type, content, fileName };
  if (state.sessionType === 'private') payload.receiverId = state.session; else payload.groupId = state.session;
  await api('/api/messages', { method: 'POST', body: JSON.stringify(payload) });
}

function connectWs() {
  if (state.stomp) state.stomp.disconnect();
  const sock = new SockJS('/ws');
  state.stomp = Stomp.over(sock);
  state.stomp.connect({}, async () => {
    const friends = await api(`/api/friends/${state.currentUserId}`);
    friends.forEach(f => {
      const key = [state.currentUserId, f.friendId].sort((a,b)=>a-b).join('-');
      state.stomp.subscribe(`/topic/private-${key}`, msg => {
        const body = JSON.parse(msg.body);
        const matched = state.sessionType === 'private' && state.session === f.friendId;
        if (matched) addMessage(body);
      });
    });
    const groups = await api(`/api/groups/${state.currentUserId}`);
    groups.forEach(g => state.stomp.subscribe(`/topic/group-${g.id}`, msg => {
      const body = JSON.parse(msg.body);
      if (state.sessionType === 'group' && state.session === g.id) addMessage(body);
    }));
  });
}

let recorder, chunks = [];
el.voiceBtn.onmousedown = async () => {
  const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
  recorder = new MediaRecorder(stream); chunks = [];
  recorder.ondataavailable = e => chunks.push(e.data);
  recorder.start(); el.voiceBtn.textContent = '松开发送';
};
el.voiceBtn.onmouseup = async () => {
  if (!recorder) return;
  recorder.onstop = async () => {
    const blob = new Blob(chunks, { type: 'audio/webm' });
    const reader = new FileReader();
    reader.onload = () => sendText(reader.result, 'VOICE', 'voice.webm');
    reader.readAsDataURL(blob);
  };
  recorder.stop(); el.voiceBtn.textContent = '按住录音';
};

el.sendBtn.onclick = async () => {
  const text = el.input.value.trim();
  if (!text) return;
  await sendText(text); el.input.value = '';
};
el.emojiBtn.onclick = () => el.emojiPanel.classList.toggle('hidden');
el.emojiPanel.onclick = e => { el.input.value += e.target.textContent; };
el.plusBtn.onclick = () => el.plusPanel.classList.toggle('hidden');
el.plusPanel.onclick = async e => {
  const action = e.target.dataset.action;
  if (action === 'file') el.fileInput.click();
  if (action === 'voicecall') await sendText('发起了语音聊天', 'SYSTEM');
  if (action === 'videocall') await sendText('发起了视频聊天', 'SYSTEM');
};
el.fileInput.onchange = async e => {
  const file = e.target.files[0]; if (!file) return;
  const reader = new FileReader();
  reader.onload = () => sendText(reader.result, 'FILE', file.name);
  reader.readAsDataURL(file);
};

document.body.onclick = async e => {
  const li = e.target.closest('li[data-id]');
  if (li) {
    state.session = Number(li.dataset.id); state.sessionType = li.dataset.type;
    document.querySelectorAll('.list li').forEach(n => n.classList.remove('active')); li.classList.add('active');
    el.chatTitle.textContent = li.textContent.trim();
    await loadHistory();
  }
  const recall = e.target.dataset.recall;
  if (recall) {
    await api(`/api/messages/${recall}/recall`, { method: 'POST', body: JSON.stringify({ userId: String(state.currentUserId) }) });
    await loadHistory();
  }
  const remark = e.target.dataset.remark;
  if (remark) {
    const r = prompt('输入新备注');
    if (r !== null) {
      await api('/api/friends/remark', { method: 'PATCH', body: JSON.stringify({ userId: String(state.currentUserId), friendId: String(remark), remark: r }) });
      await loadContacts();
    }
  }
};

el.currentUser.onchange = async () => {
  state.currentUserId = Number(el.currentUser.value); state.session = null; state.sessionType = null; el.msgArea.innerHTML = '';
  await loadContacts(); connectWs();
};

el.newGroupBtn.onclick = async () => {
  const ids = prompt('输入要拉入群聊的好友ID，逗号分隔'); if (!ids) return;
  const name = prompt('输入群名称') || '新的群聊';
  const members = ids.split(',').map(v => Number(v.trim())).filter(Boolean);
  await api('/api/groups', { method: 'POST', body: JSON.stringify({ ownerId: state.currentUserId, name, members }) });
  await loadContacts();
};

el.renameBtn.onclick = async () => {
  const n = prompt('新昵称'); if (!n) return;
  await api(`/api/users/${state.currentUserId}/nickname`, { method: 'PATCH', body: JSON.stringify({ nickname: n }) });
  state.users = await api('/api/users'); renderUsers(); await loadContacts();
};

(async function init() {
  state.users = await api('/api/users');
  renderUsers();
  await loadContacts();
  connectWs();
})();
