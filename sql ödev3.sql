--86. a.Bu ülkeler hangileri..?
 
SELECT country , COUNT(DISTINCT country) AS country_count
FROM customers
group by country

--87. En Pahalı 5 ürün						

select product_name,unit_price from products 
group by product_name, unit_price
order by unit_price desc limit 5

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?

select customer_id, count(order_id) from orders
where customer_id = 'ALFKI'
group by customer_id


--89. Ürünlerimin toplam maliyeti

SELECT SUM(unit_price*units_in_stock)  as ToplamMaliyet FROM Products



--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select SUM(unit_price*quantity) as Total from order_details


--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products


--92. En Pahalı Ürünün Adı

select product_name from products 
order by unit_price desc limit 1

--93. En az kazandıran sipariş

select o.order_id, round(sum(quantity*unit_price)) from orders o 
join order_details od on o.order_id = od.order_id
group by o.order_id 
order by sum(quantity*unit_price) asc limit 1

--94. Müşterilerimin içinde en uzun isimli müşteri
SELECT customer_id, contact_name
FROM customers
ORDER BY LENGTH(contact_name) DESC
LIMIT 1;
--95. Çalışanlarımın Ad, Soyad ve Yaşları

SELECT 
    e.first_name || ' ' || e.last_name AS full_name,
    EXTRACT(YEAR FROM age(current_date, e.birth_date)) AS age
FROM employees e;


--96. Hangi üründen toplam kaç adet alınmış..?

select product_id , sum(quantity) from order_details
group by product_id order by  sum(quantity) desc

--97. Hangi siparişte toplam ne kadar kazanmışım..?

select order_id, round(sum(unit_price*quantity)) from order_details
group by order_id 

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.category_id,c.category_name, count(product_id) from products p
join categories c on c.category_id = p.category_id
group by c.category_id,c.category_name


--99. 1000 Adetten fazla satılan ürünler?

select  product_id  ,sum(quantity) as total from order_details
group by product_id
having sum(quantity) > 1000

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.company_name,o.customer_id from orders o
right join customers c  on c.customer_id = o.customer_id
where o.customer_id is null


--101. Hangi tedarikçi hangi ürünü sağlıyor ?
select s.company_name,p.product_name from products p
join suppliers s on s.supplier_id = p.supplier_id
group by s.company_name, p.product_name


--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?

select order_id, ship_name, shipped_date from orders
group by order_id, ship_name, shipped_date
 
--103. Hangi siparişi hangi müşteri verir..?
SELECT o.order_id,o.customer_id, c.contact_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;


--104. Hangi çalışan, toplam kaç sipariş almış..?

select e.employee_id, count(o.order_id) from employees e
join orders o on o.employee_id = e.employee_id
group by e.employee_id


--105. En fazla siparişi kim almış..?

select e.employee_id, count(o.order_id) from orders o join employees e on 
e.employee_id = o.employee_id
group by e.employee_id, e.first_name, e.last_name
order by count(o.order_id) desc
limit 1

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?

select o.order_id, e.first_name || ' ' || e.last_name as worker, c.contact_name as customer from orders o 
join employees e 
on e.employee_id = o.employee_id
join customers c
on c.customer_id = o.customer_id


--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?


select p.product_name, c.category_name, s.contact_name from products p join categories c on c.category_id = p.category_id
join suppliers s on s.supplier_id = p.supplier_id

--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış

SELECT
    orders.order_id,
    customers.company_name,
	employees.first_name,
    employees.last_name,
    orders.order_date,
    shippers.company_name,
    products.product_name,
    od.quantity,
    od.unit_price,
    categories.category_name,
    suppliers.company_name
FROM
    orders
JOIN
    customers ON orders.customer_id = customers.customer_id
JOIN
    employees ON orders.employee_id = employees.employee_id
JOIN
    shippers ON orders.ship_via = shippers.shipper_id
JOIN
    order_details od ON orders.order_id = od.order_id
JOIN
    products ON od.product_id = products.product_id
JOIN
    categories ON products.category_id = categories.category_id
JOIN
    suppliers ON products.supplier_id = suppliers.supplier_id;

--109. Altında ürün bulunmayan kategoriler

SELECT
    c.category_id,
    c.category_name
FROM
    Categories c
LEFT JOIN
    Products p ON c.category_id = p.category_id
WHERE
    p.product_id IS NULL;

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.


select * from customers where  contact_title ilike '%Manager'



--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.

select customer_id,contact_name from customers
where contact_name like('Fr%')

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.

select * from customers where phone like '%(171)%'

--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.

select product_id,product_name,quantity_per_unit from products
where quantity_per_unit like('%boxes%')

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)

select * from customers c where c.country in ('Germany', 'France') and c.contact_title ilike '%manager%'

--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.


select * from products p order by p.unit_price desc limit 10

--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.

SELECT
    country,
    city,
    contact_name
FROM
    customers
ORDER BY
    country,
    city,
    contact_name;


--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.

select first_name,last_name,(DATE_PART('year',CURRENT_DATE)-DATE_PART('year',birth_date)) as ages from employees


--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
SELECT order_id,
shipped_date - order_date as gün
FROM orders
WHERE shipped_date IS NOT NULL
   AND shipped_date - order_date > 35;

--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)

SELECT category_name
FROM categories
WHERE category_id = (
    SELECT category_id
    FROM products
    WHERE unit_price = (
        SELECT MAX(unit_price)
        FROM products
    )
);


--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)


SELECT
    p.product_name,
    SUM(od.quantity) AS satılan_adet
FROM
    products p
JOIN
    order_details od ON p.product_id = od.product_id
WHERE
    p.product_name = 'Konbu'
GROUP BY
    p.product_name;

--121. Konbu adlı üründen kaç adet satılmıştır.


SELECT
    p.product_name,
    SUM(od.quantity) AS satılan_adet
FROM
    products p
JOIN
    order_details od ON p.product_id = od.product_id
WHERE
    p.product_name = 'Konbu'
GROUP BY
    p.product_name;

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.

SELECT
    COUNT(DISTINCT p.productid) AS farklıürün_sayısı
FROM
    suppliers s
JOIN
    products p ON s.supplier_id = p.supplier_id
WHERE
    s.country = 'Japan';

--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?

SELECT
    MAX(freight) AS en_yükseknakliyeücreti,
    MIN(freight) AS en_düşüknakliyeücreti,
    AVG(freight) AS ortalamanakliyeücreti
FROM
    orders
WHERE
    DATE_PART('year', order_date) = 1997;


--124. Faks numarası olan tüm müşterileri listeleyiniz.
SELECT
    contact_Name,
    fax
FROM
    customers
WHERE
    fax IS NOT NULL;


--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
SELECT
    order_id,
    order_date,
    shipped_date
FROM
    orders
WHERE
    shipped_date BETWEEN '1996-07-16' AND '1996-07-30';