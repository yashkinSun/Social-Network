// Пример периодического запроса уведомлений
setInterval(function() {
    fetch('/notification/get')
      .then(response => response.json())
      .then(data => {
        if (data.length > 0) {
          console.log("Новые уведомления:", data);
          // Здесь можно обновлять интерфейс
        }
      })
      .catch(err => console.error(err));
  }, 15000);
  