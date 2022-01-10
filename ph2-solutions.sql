/* SQL "Sakila" database query exercises - phase 1 */

-- Database context
USE sakila;

-- Your solutions...

Phase 2. Longer, Harder, More Realistic.

Use google as lightly as possible in solving these. These are the kind of queries that any data engineer should be able to perform on a familiar dataset.


1a. Display the first and last names of all actors from the table actor.

  select first_name, last_name from actor;


1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

  select Concat(first_name,' ',  last_name) as actor_name from actor;


2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
  select Concat(actor_id,' ',first_name,' ',last_name) 
      -> as actors_id
      -> from actor
      -> where first_name = 'Joe';

2b. Find all actors whose last name contain the letters GEN:
    select last_name from actor where last_name  like '%G%' and last_name like '%E%' and last_name like '%N%';


2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
    select last_name,first_name from actor where last_name like '%L%' and last_name like '%I%' order by last_name, first_name;

2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
    select * from country
    where country in ('Afghanistan', 'Bangladesh', 'China');

3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
    alter table actor add middle_name varchar(55)
    -> after first_name;

3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
      alter table actor change middle_name middle_name blob;

3c. Now delete the middle_name column.
    alter table actor
    -> drop column middle_name;

4a. List the last names of actors, as well as how many actors have that last name.
    select last_name, count(*) as 'Actor Total' from actor group by last_name;

4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
    select last_name, count(*) as 'duplicate last name' from actor group by last_name having count(*) >= 2;

4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
    update actor set first_name = 'Harpo' where first_name = 'Groucho' and last_name = 'Williams';

4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
    update actor
    -> set first_name = 'Groucho'
    -> where actor_id = 172;

5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
    create table address (
      actor_id varchar(255),
      street varchar(255)
      city varchar(255),
      state varchar(255),
      zipcode varchar(255)
      country varchar(255)
      );

Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
    select first_name, last_name, address
    -> from staff s
    -> join address a
    -> on s.address_id = a.address_id;

6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
        select payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
        from staff inner join payment on staff.staff_id = payment.staff_id and payment_date like '2005-08%';

6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
        select f.title as 'film title',
        count(fa.actor_id) as 'number of actors' from film_actor fa inner join film f
        on fa.film_id=f.film_id group by f.title;

6d. How many copies of the film Hunchback Impossible exist in the inventory system?
      select title, (
    -> select count(*) from inventory
    -> where film.film_id=inventory.film_id)
    -> as 'copies'
    -> from film
    -> where title = 'Hunchback Impossible';

6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
    select 

7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
    select title
    -> from film where title 
    -> like 'K%' or title like 'Q%'
    -> and title in 
    -> (
    -> select title 
    -> from film 
    -> where language_id = 1
    -> );

7b. Use subqueries to display all actors who appear in the film Alone Trip.
    select first_name, last_name
    -> from actor
    -> where actor_id in 
    -> (
    -> select actor_id
    -> from film_actor
    -> where film_id in
    -> (
    -> select film_id
    -> from film
    -> where title = 'Alone Trip'
    -> ));

7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
    select c.first_name, c.last_name, c.email
    -> from customer c
    -> join address a
    -> on (c.address_id = a.address_id)
    -> join city cty
    -> on (cty.city_id = a.city_id)
    -> join country
    -> on (country.country_id=cty.country_id)
    -> where country.country='Canada';

7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
    select title, description from film where film_id in
    -> (select film_id from film_category where category_id in
    -> (select category_id from category where name = 'Family' ));

7e. Display the most frequently rented movies in descending order.
    select f.title, count(rental_id) as 'rented'
    -> from rental r
    -> join inventory i
    -> on (r.inventory_id=i.inventory_id)
    -> join film f
    -> on (i.film_id=f.film_id)
    -> group by f.title
    -> order by 'rented' desc;

7f. Write a query to display how much business, in dollars, each store brought in.
    select s.store_id, sum(amount) as 'revenue'
    -> from payment p
    -> join rental r
    -> on (p.rental_id=r.rental_id)
    -> join inventory i
    -> on (i.inventory_id=r.inventory_id)
    -> join store s
    -> on (s.store_id=i.store_id)
    -> group by s.store_id;   

7g. Write a query to display for each store its store ID, city, and country.
    select s.store_id, cty.city, country.country
    -> from store s
    -> join address a
    -> on (s.address_id=a.address_id)
    -> join city cty
    -> on (cty.city_id=a.city_id)
    -> join country
    -> on(country.country_id=cty.country_id);

7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
    select c.name as 'genre', sum(p.amount) as 'gross'
    -> from category c
    -> join film_category fc
    -> on(c.category_id=fc.category_id)
    -> join inventory i
    -> on (fc.film_id=i.film_id)
    -> join rental r
    -> on(i.inventory_id=r.inventory_id)
    -> join payment p
    -> on(r.rental_id=p.rental_id)
    -> group by c.name order by gross limit 5;

8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
      create view generate_revenue as
      -> select c.name as 'genre', sum(p.amount) as 'gross'
      -> from category c
      -> join film_category fc
      -> on(c.category_id=fc.category_id)
      -> join inventory i
      -> on(fc.film_id=i.film_id)
      -> join rental r
      -> on(i.inventory_id=r.inventory_id)
      -> join payment p
      -> on(r.rental_id=p.rental_id)
      -> group by c.name order by gross limit 5;

8b. How would you display the view that you created in 8a?
    select * from genre_revenue;

8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
    drop view genre_revenue;

