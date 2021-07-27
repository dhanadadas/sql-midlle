/* пояснения к заданию
   По формуле которая была предложена у меня есть вопросы
   на которые мне не дали пояснений.
   Например что за индекс j используется в формуле.
   Я нашел в интернете формулу, по который расчитывается
   данное значение и сделал по ней.
   Наценка средневзв  = Доля1 х  Наценка1 в % + Доля2 х  Наценка2 в % + ... + Доляn  х  Наценка n в %
   Источник: http://amordvinkin.ru/index.php/publishing/2-uncategorised/83-opiucross-text5
 */

SELECT sum(result.СредВзвешеннаяНаценка), Товар.Кодгруппы
FROM (
         SELECT
             -- t2.Цена As ЦенаПродажи, -- промежуточные данные
             -- t1.Цена As ЦенаЗакупки, -- промежуточные данные
             -- (t2.Цена - t1.Цена)/t1.Цена * 100 AS Наценка, -- промежуточные данные
             -- (t2.Цена*t2.Количество)/sumSale.СуммаПродажЗаПериод as Доля, -- доля
             -- ( (t2.Цена*t2.Количество)/sumSale.СуммаПродажЗаПериод )*(t2.Цена - t1.Цена)/t1.Цена * 100 AS ВзвешеннаяНаценка,
             sum(
                 ((t2.Цена * t2.Количество) / sumSale.СуммаПродажЗаПериод) *
                 (t2.Цена - t1.Цена) / t1.Цена *
                 100
                 ) AS СредВзвешеннаяНаценка,
             t1.КодТовара
         FROM Продажа AS t1
                  LEFT JOIN Закупка AS t2 ON t2.КодЗакупки = t1.КодЗакупки
                  left JOIN (
             SELECT sum(t1.Цена * t1.Количество) AS СуммаПродажЗаПериод,
                    t1.КодТовара
             FROM Продажа AS t1
                      LEFT JOIN Закупка AS t2 ON t2.КодЗакупки = t1.КодЗакупки
             WHERE t1.Дата BETWEEN '2016-01-21'
                 AND '2016-02-29'
               AND t2.Дата BETWEEN '2016-01-21'
                 AND '2016-02-29'
             GROUP BY t1.КодТовара
         ) AS sumSale ON sumSale.Кодтовара = t1.Кодтовара
         WHERE t1.Дата BETWEEN '2016-01-21'
             AND '2016-02-29'
           AND t2.Дата BETWEEN '2016-01-21'
             AND '2016-02-29'
         GROUP BY t1.КодТовара
     ) as result
         left JOIN Товар ON Товар.КодТовара = result.КодТовара
GROUP BY Товар.Кодгруппы