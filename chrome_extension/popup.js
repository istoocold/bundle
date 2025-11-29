document.getElementById('help').addEventListener('click', (e) => {
  e.stopPropagation();
  document.getElementById('instructions').classList.add('show');
});

document.getElementById('dismiss').addEventListener('click', (e) => {
  e.stopPropagation();
  document.getElementById('instructions').classList.remove('show');
});

document.getElementById('instructions').addEventListener('click', (e) => {
  if (e.target.id === 'instructions') {
    document.getElementById('instructions').classList.remove('show');
  }
});

document.getElementById('repo').addEventListener('click', (e) => {
  e.stopPropagation();
  chrome.tabs.create({ url: 'https://github.com/istoocold/bundle/' });
});