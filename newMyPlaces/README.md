Приложение "Мои любимые места", с возможность добавлять, задавать рейтинг, адрес и маршрут от пользователя до заведения.
Данные можно найти по поиску или отсортировать в любом порядке по дате или имени.

<img width="1280" alt="MyPlacesMain" src="https://user-images.githubusercontent.com/31091846/120179091-d5f90a00-c212-11eb-8fec-5791f83bf68f.png">

Добавление нового места с названием, типом, рейтингом и местоположением с возможностью добавить описание и комментирование.

<img width="1280" alt="mPl_addPlace" src="https://user-images.githubusercontent.com/31091846/120179521-5d467d80-c213-11eb-98d0-39592162fd2c.png">

Все данные и координаты могут меняться и редактироваться

<img width="1280" alt="mPl_editPlace" src="https://user-images.githubusercontent.com/31091846/120179873-ccbc6d00-c213-11eb-9d7a-1a8cec46fe9f.png">

Для понимая, как работает рейтинг, инициализировал emptyStar, filledStar, highlightedStar, с дальнейшем переходом на библиотеку cosmosStar с огромным функционалом.

<img width="1280" alt="mPl_rating" src="https://user-images.githubusercontent.com/31091846/120185354-bf56b100-c21a-11eb-8bdc-738ff97ea93a.png">

CLLocationManager() // для управления всеми действиями, связанными с метоположением пользователя
CLGeocoder для преобразования местоположения в координаты
MKPointAnnotation для описания точки на карте
Проверем включение. служб отслеживания местоположения и создаем alert для объяснения, как это сделать

<img width="1280" alt="mPl_mapManager" src="https://user-images.githubusercontent.com/31091846/120184940-3b9cc480-c21a-11eb-969c-12b637e4abf5.png">


