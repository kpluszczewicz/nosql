# Technologie NOSQL

## Baza danych
Moja baza danych znajduje się pod adresem http://sigma.ug.edu.pl:14017/infochimps. W bazie tej znajdują się wpisy z twittera, które w treści wiadomości zawierają słówko „cheese”. Oryginalnych danych było około 150Mb. Ja wybrałem sobie jedynie te dane, które zawierały informacje geolokacyjne.

## Skrypt data2couch.rb

data2couch jest to skrypt, który wczytuje dane z pliku (zawierającego wpisy w formacie json), a następnie umieszczający je w bazie couchdb

Wywołanie:

	data2couch plik.json couchdbserv

Skrypt posłużył mi do stworzenia bazy opisanej w pierwszym punkcie

## Widoki

W pliku cheese\_views.js znajduje się kilka widoków działających na bazie *infochimps* na moim couchdb.

- **by\_each\_day**  
  W tym widoku dostajemy klucze, które są znacznikami czasowymi danego dnia, w którym został zanotowany wpis na twitterze
- **by\_day\_of\_week**  
  Ten widok pozwala podsumować dane dla każdego dnia tygodnia (poniedziałek, wtorek...)
- **by\_user**  
  Kolejny posłużył do zliczania ile wiadomości dany użytkownik zapisał

## Listy

Plik cheese\_views.js zawiera także parę funkcji listowych:

- **all**  
  wypisuje wszystkie rekordy
- **best\_writers**  
  sortowanie po kluczach

## Wizualizacja danych

Przechodząc pod [adres](http://sigma.ug.edu.pl:14017/infochimps/_design/app/_list/tweets/by_each_day?reduce=true&group_level=1) można obejrzeć wykres częstotliwości wpisów dla kolejnych dni.
