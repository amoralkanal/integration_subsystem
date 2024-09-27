﻿#Область ПрограммныйИнтерфейс

// Возвращает цвет фона для элемента который редактируется/не редактируется
// Параметры:
//   Редактируется - Булево - Редактируется
// Возвращаемое значение:
//   Цвет - Цвет фона для элемента который редактируется/не редактируется
Функция ЦветФонаЭлементРедактируется(Редактируется = Истина) Экспорт
	
	Если Редактируется Тогда
		
		Возврат Новый Цвет(255, 255, 255);
		
	Иначе
		
		Возврат Новый Цвет(240, 240, 240);
		
	КонецЕсли;
	
КонецФункции

// Возвращает цвет текста гиперссылки
//
// Возвращаемое значение:
//   Цвет - Цвет текста
//
Функция ЦветТекстаГиперссылки() Экспорт
	
	// https://ru.wikipedia.org/wiki/%D0%92%D0%B8%D0%BA%D0%B8%D0%BF%D0%B5%D0%B4%D0%B8%D1%8F:%D0%A6%D0%B2%D0%B5%D1%82%D0%B0_%D1%81%D1%81%D1%8B%D0%BB%D0%BE%D0%BA
	// Голубая ссылка
	Возврат Новый Цвет(51, 102, 187);
	
КонецФункции

// Возвращает цвет текста важной гиперссылки
//
// Возвращаемое значение:
//   Цвет - Цвет текста
//
Функция ЦветТекстаВажнойГиперссылки() Экспорт
	
	Возврат Новый Цвет(125, 0, 0);
	
КонецФункции

Функция ЦветТекстаНедоступно() Экспорт
	
	Возврат Новый Цвет(100, 100, 100);
	
КонецФункции

// Возвращает шрифт жирный
// Возвращаемое значение:
//   Шрифт - Шрифт
Функция ШрифтЖирный() Экспорт
	Возврат Новый Шрифт( , , Истина);
КонецФункции

// Возвращает шрифт жирный 120%
// Возвращаемое значение:
//   Шрифт - Шрифт
Функция ШрифтЖирный120() Экспорт
	
	Возврат Новый Шрифт( , , Истина, , , , 120);
	
КонецФункции

// Возвращает шрифт зачеркнутый
//
// Возвращаемое значение:
//   Шрифт - Шрифт
//
Функция ШрифтЗачеркнутый120() Экспорт
	
	Возврат Новый Шрифт( , , , , , Истина, 120);
	
КонецФункции

// Возвращает основное расширение файлов данных, которое используется для сохранения
// Возвращаемое значение:
//   Строка - Основное расширение файлов данных
Функция ОсновноеРасширениеФайловДанных() Экспорт
	Возврат "mcr";
КонецФункции

// Возвращает строку фильтра для диалога выбора файла
//
// Параметры:
//   ВключаяВсеФайлы - Булево - Включать все файлы
//   ВключатьИмпортируемыеФорматы - Булево - Включать импортируемые форматы
//
// Возвращаемое значение:
//   Строку - Фильтр для диалога выбора файла
//
Функция ФильтрФайловДанных(ВключаяВсеФайлы = Ложь, ВключатьИмпортируемыеФорматы = Ложь) Экспорт
	
	ПоддерживаемыеФорматы = Новый СписокЗначений;
	ПоддерживаемыеФорматы.Добавить(СтрШаблон("*.%1", ОсновноеРасширениеФайловДанных()), НСтр("ru = 'Файлы данных'; en = 'Data files'"));
	Если ВключатьИмпортируемыеФорматы Тогда
		ПоддерживаемыеФорматы.Добавить("*.q1c", НСтр("ru = 'Файлы запросов от 1С'; en = 'Query files from 1C'"));
		ПоддерживаемыеФорматы.Добавить("*.dcr", НСтр("ru = 'Файлы СКД от 1С'; en = 'DCS files from 1C'"));
		ПоддерживаемыеФорматы.Добавить("*.erf", НСтр("ru = 'Файлы внешних отчетов (СКД)'; en = 'External report files (DCS)'"));
	КонецЕсли;
	
	Возврат ФильтрФайлов(ПоддерживаемыеФорматы, ВключаяВсеФайлы);
	
КонецФункции

// Возвращает строку фильтра для диалога выбора файла
//
// Параметры:
//   Форматы - СписокЗначений - Формат (Представление..., Значение - Расширение)
//   ВключаяВсеФайлы - Булево - Включать все файлы
//
// Возвращаемое значение:
//   Строку - Фильтр для диалога выбора файла
//
Функция ФильтрФайлов(Форматы, ВключаяВсеФайлы = Истина) Экспорт
	
	Фильтры = Новый Массив;
	
	Если Форматы.Количество() > 1 Тогда
		Фильтры.Добавить(СтрокаФильтраФайлов(НСтр("ru = 'Все поддерживаемые форматы'; en = 'All supported format'"), СтрСоединить(Форматы.ВыгрузитьЗначения(), ";")));
	КонецЕсли;
	
	Для Каждого Формат Из Форматы Цикл
		Фильтры.Добавить(СтрокаФильтраФайлов(Формат.Представление, Формат.Значение));
	КонецЦикла;

	Если ВключаяВсеФайлы Тогда
		Фильтры.Добавить(СтрокаФильтраФайлов(НСтр("ru = 'Все файлы'; en = 'All files'"), ПолучитьМаскуВсеФайлы()));
	КонецЕсли;
	
	Возврат СтрСоединить(Фильтры, "|");
	
КонецФункции

// Возвращает последнюю поддерживаемую версию формата MCR
// Возвращаемое значение:
//   Строку - Последняя версия MCR
Функция MCRПоддерживаемаяВерсия() Экспорт
	
	Возврат "2.1";
	
КонецФункции

// Создает копию объекта
// Параметры:
//   Объект - Произвольный - Произвольный объект
// Возвращаемое значение:
//   Произвольный - Копия объекта
//
Функция СкопироватьОбъект(Объект) Экспорт
	
	КопияОбъекта = Новый (ТипЗнч(Объект));
	Если ТипЗнч(Объект) = Тип ("Соответствие") Тогда
		
		Для Каждого Элемент Из Объект Цикл
			КопияОбъекта.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип ("Структура") Тогда
		
		Для Каждого Элемент Из Объект Цикл
			КопияОбъекта.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип ("СписокЗначений") Тогда
		
		Для Каждого Элемент Из Объект Цикл
			КопияОбъекта.Добавить(Элемент.Значение, Элемент.Представление, Элемент.Пометка, Элемент.Картинка);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат КопияОбъекта;
	
КонецФункции

// Возвращает код английского языка
// Возвращаемое значение:
//   Строка	- Код английского языка
//
Функция КодЯзыкаАнглийский() Экспорт
	
	Возврат "en";
	
КонецФункции

// Возвращает код русского языка
// Возвращаемое значение:
//   Строка	- Код русского языка
//
Функция КодЯзыкаРусский() Экспорт
	
	Возврат "ru";
	
КонецФункции

// Возвращает представление ошибки в тексте
// Параметры:
//   Ошибка - Ошибка - Ошибка
// Возвращаемое значение:
//   Строка	- Представление ошибки в тексте
//
Функция ПредставлениеОшибкиВТекстеЗапросаИлиСхемеКомпоновкиДанных(Ошибка) Экспорт
	
	Если Ошибка = Неопределено Тогда
		
		Результат = "";
	
	ИначеЕсли ТипЗнч(Ошибка) = Тип("Строка") Тогда
			
		Результат = Ошибка;
		
	Иначе
		
		Результат = СтрШаблон("(%1, %2) %3", ИТКВ_Строки.ЧислоВСтроку(Ошибка.НомерСтроки), Ошибка.НомерСтолбца, Ошибка.Текст);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет это является ли значение ссылкой
//
// Параметры:
//  Ссылка  - Ссылка - Ссылка
//  ИсключаяПеречисления  - Булево - Исключать перечисление из ссылочных типов
//
// Возвращаемое значение:
//   Булево - Истина, это ссылка
//
Функция ЭтоСсылка(Ссылка, ИсключаяПеречисления = Ложь) Экспорт
	
	Если Ссылка = Неопределено Тогда
		
		Результат = Ложь;
		
	Иначе
		
		Результат = ИТКВ_ТипыКлиентСервер.ЭтоСсылочный(ТипЗнч(Ссылка), ИсключаяПеречисления);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает список значений конструируя на основании значения (добавляем значение в список)
//
// Параметры:
//   Значение - Произвольный - Значение
//
// Возвращаемое значение:
//   СписокЗначений - Результат
//
Функция НовыйСписокЗначений(Значение) Экспорт
	
	Результат = Новый СписокЗначений;
	Результат.Добавить(Значение);
	
	Возврат Результат;
	
КонецФункции

// Проверяет, является ли значение, значение параметра типа граница (сложный параметр)
//
// Параметры:
//   Значение - Структура - Значение параметра (сложный параметр)
//
// Возвращаемое значение:
//   Булево - Истина, если значение - граница
//
Функция ЭтоЗначениеПараметраГраница(Значение) Экспорт
	
	Возврат ТипЗнч(Значение) = Тип("Структура")
				И Значение.Вид = ИТКВ_Перечисления.СложныйПараметрЗапросаГраница();
	
КонецФункции

// Проверяет это режим выполнения с результатом
//
// Параметры:
//  Режим  - Перечисление.ИТКВ_РежимВыполненияЗапроса, Перечисление.ИТКВ_РежимВыполненияСхемыКомпоновкиДанных - Режим выполнения
//
// Возвращаемое значение:
//   Булево - Истина, Режим выполнения с результатом
//
Функция ЭтоРежимВыполненияСРезультатом(Режим) Экспорт
	
	Возврат Режим = ИТКВ_Перечисления.РежимВыполненияЗапросаВыполнение()
		ИЛИ Режим = ИТКВ_Перечисления.РежимВыполненияЗапросаСРезультатамиВременныхТаблиц()
		ИЛИ Режим = ИТКВ_Перечисления.РежимВыполненияСКДВыполнение()
		ИЛИ Режим = ИТКВ_Перечисления.РежимВыполненияКодаВыполнение()
		ИЛИ Режим = ИТКВ_Перечисления.РежимВыполненияКодаНаКлиенте();
	
КонецФункции

// Сохраняет текст в файл
//
// Параметры:
//   ИмяФайла - Строка - Полное имя файла
//   Текст - Строка - Сохраняемый текст
//
Процедура СохранитьТекстВФайл(ИмяФайла, Текст) Экспорт
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла);
	ЗаписьТекста.Записать(Текст);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

// Ожидает, делает паузу на заданное количество, секунл
//
// Параметры:
//  КоличествоСекунд  - Число - Количество, секунл
//
Процедура Подождать(КоличествоСекунд) Экспорт
	
	Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	Пока (ТекущаяУниверсальнаяДатаВМиллисекундах() - Начало) < (КоличествоСекунд * 1000) Цикл
		
	КонецЦикла;
	
КонецПроцедуры

// Получает значение свойства структуры
//
// Параметры:
//   Структура - Структура - Структура
//   Имя - Строка - Имя свойства
//   ЗначениеПоУмолчанию - Произвольный - Значение по умолчанию, когда в данной структуре нет этого свойства
//
// Возвращаемое значение:
//   Произвольный - Значение свойства структуры
//
Функция Свойство(Структура, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если Структура = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Если Структура.Свойство(Ключ) Тогда
		
		Результат = Структура[Ключ];
		
	Иначе
		
		Результат = ЗначениеПоУмолчанию;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИдентификаторНастройкиБольшеНеПоказыватьВопрос(Идентификатор) Экспорт
	
	Возврат "Вопрос" + Идентификатор + "БольшеНеПоказывать";
	
КонецФункции

Функция ПометкаДереваЗначений(Строка) Экспорт
	
	ВсеУстановлены = Истина; ВсеСняты = Истина;
	Для Каждого ПодчиненнаяСтрока Из Строка.Строки Цикл
		
		Если ЗначениеЗаполнено(ПодчиненнаяСтрока.Строки) Тогда
			
			Пометка = ПометкаДереваЗначений(ПодчиненнаяСтрока);
			ПодчиненнаяСтрока.Пометка = Пометка;
			
		Иначе
			
			Пометка = ПодчиненнаяСтрока.Пометка;
			
		КонецЕсли;
		
		Если Пометка = 2 Тогда
			
			ВсеСняты = Ложь;
			ВсеУстановлены = Ложь;
			
			Прервать;
			
		ИначеЕсли Пометка Тогда
			
			ВсеСняты = Ложь;
			
		Иначе
			
			ВсеУстановлены = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПометкаТриСостояния(ВсеУстановлены, ВсеСняты);
	
КонецФункции

Функция ПометкаТриСостояния(ВсеУстановлены, ВсеСняты) Экспорт
	
	Если ВсеУстановлены Тогда
		
		Результат = 1;
		
	ИначеЕсли ВсеСняты Тогда
		
		Результат = 0;
		
	Иначе
		
		Результат = 2;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КоличествоПомеченныхВКоллекции(Список) Экспорт
	
	Результат = 0;
	
	Для Каждого Элемент Из Список Цикл
		
		Если Элемент.Пометка Тогда
			Результат = Результат + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ЭтоПустаяДата(Дата) Экспорт
	
	Возврат (Дата = ПустаяДата());
	
КонецФункции

Функция ОбратноеСоответствие(Значение) Экспорт
	
	Результат = Новый Соответствие;
	Для Каждого Элемент Из Значение Цикл
		
		Результат.Вставить(Элемент.Значение, Элемент.Ключ);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПоложениеЗаголовкаАвтоВверхПоДлине(Строка, Длина) Экспорт
	
	Если СтрДлина(Строка) > Длина Тогда
		
		Результат = ПоложениеЗаголовкаЭлементаФормы.Верх;
		
	Иначе
		
		Результат = ПоложениеЗаголовкаЭлементаФормы.Авто;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПустаяДата() Экспорт
	
	Возврат Дата(1, 1, 1);
	
КонецФункции

// Возвращает представление времени в миллисекундах
//
// Параметры:
//   ЧислоМиллисекунд - Число - Число миллисекунд
//
// Возвращаемое значение:
//   Строка - Представление времени в миллисекундах
//
Функция ПредставлениеВремениВМс(ЧислоМиллисекунд) Экспорт
	
	Если ЧислоМиллисекунд = Неопределено Тогда
		
		Результат = "<?>";
		
	ИначеЕсли ЧислоМиллисекунд = 0 Тогда
		
		Результат = НСтр("ru = '< 1 мс'; en = '< 1 ms'");
		
	ИначеЕсли ЧислоМиллисекунд < 100 Тогда
		
		Результат = СтрШаблон(НСтр("ru = '%1 мс'; en = '%1 ms'"), ЧислоМиллисекунд);
		
	Иначе
		
		Если ЧислоМиллисекунд < 100 Тогда
			ТочностьСекунд = 3;
		ИначеЕсли ЧислоМиллисекунд < 5000 Тогда
			ТочностьСекунд = 2;
		Иначе
			ТочностьСекунд = 1;
		КонецЕсли;
		ВремяВСекундах = Окр(ЧислоМиллисекунд / 1000, ТочностьСекунд);
		
		ВремяМинут = Цел(ВремяВСекундах / 60);
		ВремяВСекундах = ВремяВСекундах % 60;
		
		ЭлементыПредставления = Новый Массив;
		Если ЗначениеЗаполнено(ВремяМинут) Тогда
			ЭлементыПредставления.Добавить(СтрШаблон(НСтр("ru = '%1 мин.'; en = '%1 min.'"), Формат(ВремяМинут, "ЧГ=")));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВремяВСекундах) Тогда
			ЭлементыПредставления.Добавить(СтрШаблон(НСтр("ru = '%1 с.'; en = '%1 s.'"), ВремяВСекундах));
		КонецЕсли;
		
		Результат = СтрСоединить(ЭлементыПредставления, " ");
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция МиллисекВСек(Число, Точность = 3) Экспорт
	
	МиллисекундВСекунде = 1000;
	Возврат Окр(Число / МиллисекундВСекунде, Точность);
	
КонецФункции

Функция КоличествоСекундВДне() Экспорт
	
	Возврат 24 * 60 * 60;
	
КонецФункции

Функция ПроцентОтОбщего(Число, Всего, Точность = 2) Экспорт
	
	СтоПроцентов = 100;
	Возврат Окр((Число * СтоПроцентов) / Всего, Точность);

КонецФункции

Функция СравнитьВерсии(ПерваяВерсия, ВтораяВерсия) Экспорт
	
	Если Не ЗначениеЗаполнено(ПерваяВерсия) Тогда
		Возврат -1;
	КонецЕсли;
	
	ЧастиПервойВерсии = СтрРазделить(ПерваяВерсия, ".");
	ЧастиВторойВерсии = СтрРазделить(ВтораяВерсия, ".");
	
	Граница = Мин(ЧастиПервойВерсии.ВГраница(), ЧастиВторойВерсии.ВГраница());

	Результат = 0;
	Для Счетчик = 0 По Граница Цикл
		
		Если Число(ЧастиПервойВерсии[Счетчик]) > Число(ЧастиВторойВерсии[Счетчик]) Тогда
			
			Результат = 1;
			Прервать;
			
		ИначеЕсли Число(ЧастиПервойВерсии[Счетчик]) < Число(ЧастиВторойВерсии[Счетчик]) Тогда
			
			Результат = -1;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПоддерживаетсяПлатформой(Версия) Экспорт
	
	Возврат (СравнениеВерсииПлатформыСТекущей(Версия) <> -1);
	
КонецФункции

Функция СписокЗначенийНайтиПоПредставлению(СписокЗначений, Представление) Экспорт
	
	Результат = Неопределено;
	Для Каждого Элемент Из СписокЗначений Цикл
		
		Если Элемент.Представление = Представление Тогда
			Результат = Элемент;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Дополняет массив Приемник значениями из массива Источник.
//
// Параметры:
//  Приемник - Массив - массив, в который необходимо добавить значения.
//  Источник - Массив - массив значений для заполнения.
//  ТолькоУникальныеЗначения - Булево - если истина, то в массив будут включены только уникальные значения.
//
Процедура ДополнитьМассив(Приемник, Источник, ТолькоУникальныеЗначения = Ложь) Экспорт
	
	Если ТипЗнч(Источник) <> Тип("Массив") Тогда
		
		ДобавитьЗначениеВМассив(Приемник, Источник, ТолькоУникальныеЗначения);
		Возврат;
		
	КонецЕсли;
		
	Если ТолькоУникальныеЗначения Тогда
		
		УникальныеЗначения = Новый Соответствие;
		
		Для Каждого Значение Из Приемник Цикл
			УникальныеЗначения.Вставить(Значение, Истина);
		КонецЦикла;
		
		Для Каждого Значение Из Источник Цикл
			
			Если УникальныеЗначения.Получить(Значение) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Приемник.Добавить(Значение);
			УникальныеЗначения.Вставить(Значение, Истина);
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого Значение Из Источник Цикл
			Приемник.Добавить(Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Удаляет повторяющиеся элементы массива.
//
// Параметры:
//  Массив - Массив - массив произвольных значений.
//
// Возвращаемое значение:
//  Массив - коллекция уникальных элементов.
//
Функция СвернутьМассив(Массив) Экспорт
	
	Результат = Новый Массив;
	ДополнитьМассив(Результат, Массив, Истина);
	
	Возврат Результат;
	
КонецФункции

Функция КоллекциюВJSONСтроку(Коллекция) Экспорт
	
	#Если НЕ ВебКлиент Тогда
		
		ЗаписьJSON = Новый ЗаписьJSON();
		ЗаписьJSON.УстановитьСтроку();
		
		ЗаписатьJSON(ЗаписьJSON, Коллекция);
		
		Возврат ЗаписьJSON.Закрыть();
		
	#КонецЕсли
	
КонецФункции

Функция JSONСтрокуВКоллекцию(Строка) Экспорт

	#Если НЕ ВебКлиент Тогда

		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Строка);
		Результат = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		Возврат Результат;
		
	#КонецЕсли
	
КонецФункции

Функция ПредставлениеЯзыка(КодЯзыка) Экспорт
	
	Если КодЯзыка = "ru" Тогда
		
		Результат = "Русский";
		
	ИначеЕсли КодЯзыка = "en" Тогда
		
		Результат = "English";
		
	Иначе
		
		Результат = Неопределено;
		ВызватьИсключение "Нет представления для языка";
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КодТекущегоЯзыка() Экспорт
	
	ТекущийЯзык = ТекущийЯзык();
	Если ТипЗнч(ТекущийЯзык) = Тип("Строка") Тогда
		Результат = ТекущийЯзык;
	Иначе
		Результат = ТекущийЯзык.КодЯзыка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьЗначениеВМассив(Массив, Значение, ПроверкаДублирования = Истина)
	
	ДобавитьЗначение = (ПроверкаДублирования = Ложь)
			ИЛИ Массив.Найти(Значение) = Неопределено;
		
	Если ДобавитьЗначение Тогда
		Массив.Добавить(Значение);
	КонецЕсли;
	
КонецПроцедуры

Функция СтрокаФильтраФайлов(Представление, Расширение)
	
	Возврат СтрШаблон("%1 (%2)|%2", Представление, Расширение);
	
КонецФункции

Функция СравнениеВерсииПлатформыСТекущей(ВерсияСравнения)

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ТекущаяВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
	
	Возврат СравнитьВерсии(ТекущаяВерсияПлатформы, ВерсияСравнения);

КонецФункции

#КонецОбласти
