# Черга конкурентів

Що таке черга [конкурентів](../concept/Competitor.md#конкурент) [наслідку](../concept/Consequence.md#наслідок) та як правильно
користуватись рутинами-конкурентами.

`Наслідок` це контейнер, що містить два звичайних масиви:
- чергу [ресурсів](../concept/Resource.md#ресурс);
- чергу [конкурентів](../concept/Competitor.md#конкурент);

Після створення `наслідку` необхідно додати одну або скільки завгодно рутин-конкурентів, що будуть по-черзі обробляти пізніше
переданий у `наслідок` ресурс. Ресур також можна передати до моменту додавання конкурентів.
```js
let con = new _.Consequence();

con.then( ( arg ) => arg + '1' );
con.then( ( arg ) => arg + '2' );
con.then( ( arg ) => arg + '3' );
```
Рутина `.then( callback )` є одним із конкурентів(обробником) у черзі.

Подивитись на чергу ресурсів та чергу конкурентів можна наступним способом:
```js
console.log( con.argumentsGet() ); // resources queue
// []
console.log( con.competitorsGet() ); // competitors queue
// [ {}, {}, {} ]
```

Дізнатись кількість наявних ресурсів та конкурентів у `наслідку` можна так:
```js
console.log( con );
// Consequence:: 0 / 3
```
Формат виводу `Consequence:: resources / competitors`.

Тепер передамо у `наслідок` ресурс. Це спровокує виконання всієї наявної черги із конкурентів. Щойно переданий ресурс
передається як параметр `arg` у перший конкурент, а той у свою чергу передає його наступному і так до кінця черги.
Важливо памятати, що рутина-конкурент `.take( callback )` завжди повинна щось повертати.
```js
con.take( 'a' ); // every competitor is executed in turn

console.log( con.argumentsGet() );
// [ 'a123' ]
console.log( con );
// Consequence:: 1 / 0
```
Зверніть увагу, що тепер кількість конкуркнтів у черзі - 0. Це важливий нюанс у поведінці наслідку. Оскільки при наступній
передачі ресурсу, обробити його буде нікому, якщо до моменту його передачі знову не призначити нових конкурентів. 
```js
con.take( 'b' );

// every passed resource is pushed to the resource queue array
console.log( con.argumentsGet() );
// [ 'a123', 'b' ]

console.log( con );
// Consequence:: 2 / 0
```
Даний приклад є дуже спрощеним. Яскравим прикладом асинхронної передачі ресурсу - є відповідь серверу. Коли дані, що прийшли
передаються у наслідок і далі можуть бути оброблені конкурентами.

**Підсумок:**

- наслідок структурно складається із двої черг - ресурсів та конкурентів;
- конкуренти це рутини-обробники ресурсу, що передається у наслідок;
- як тільки ресурс був переданий у наслідок, конкуренти, що були на цей момент у черзі, починають по-черзі виконуватись.
  Перший конкурент отримує як аргумент ресурс, що був щойно переданий, а повертає довільний результат, який передається
  наступному конкуренту.
- конкуренти існують у черзі поки не будуть викликані для обробки переданого ресурсу, після чого видаляються із черги.
  Наступний переданий ресурс уже не буде оброблений тими конкурентами, які обробили попередній ресурс.

[Повернутись до змісту](../README.md#туторіали)