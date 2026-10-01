async function api(url, options = {}) {
  const response = await fetch(url, { ...options, headers: { "Content-Type": "application/json", ...(options.headers || {}) } });
  const data = await response.json();
  return { response, data };
}

function showMessage(text) {
  document.querySelector("#message")?.replaceChildren(text);
}

function formData(form) {
  return Object.fromEntries(new FormData(form));
}

document.querySelector("#register-form")?.addEventListener("submit", async (event) => {
  event.preventDefault();
  const { response, data } = await api("/api/auth/registro", { method: "POST", body: JSON.stringify(formData(event.currentTarget)) });
  if (response.ok) location.href = "/login";
  else showMessage(data.detail);
});

document.querySelector("#login-form")?.addEventListener("submit", async (event) => {
  event.preventDefault();
  const { response, data } = await api("/api/auth/login", { method: "POST", body: JSON.stringify(formData(event.currentTarget)) });
  if (response.ok) location.href = "/mis-partidos";
  else showMessage(data.detail);
});

document.querySelector("#recover-form")?.addEventListener("submit", async (event) => {
  event.preventDefault();
  const { response, data } = await api("/api/auth/recuperar", { method: "POST", body: JSON.stringify(formData(event.currentTarget)) });
  showMessage(response.ok ? `Token de prueba: ${data.token}` : data.detail);
});

document.querySelector("#change-password-form")?.addEventListener("submit", async (event) => {
  event.preventDefault();
  const { response, data } = await api("/api/auth/cambiar-password", { method: "POST", body: JSON.stringify(formData(event.currentTarget)) });
  if (response.ok) location.href = "/login";
  else showMessage(data.detail);
});

async function loadPrivatePage() {
  const { response, data } = await api("/api/auth/yo");
  if (!response.ok) return location.href = "/login";
  document.querySelector("#welcome").textContent = `Hola, ${data.nombre}`;
}

if (document.body.dataset.page === "mis-partidos") loadPrivatePage();

document.querySelector("#logout")?.addEventListener("click", async () => {
  await api("/api/auth/logout", { method: "POST" });
  location.href = "/login";
});
