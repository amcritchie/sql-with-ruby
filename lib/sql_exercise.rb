require "database_connection"

class SqlExercise

  attr_reader :database_connection

  def initialize
    @database_connection = DatabaseConnection.new
  end

  def suffix(array)
    array.first["total"].to_f
  end

  def all_customers
    database_connection.sql("SELECT * from customers")
  end

  def limit_customers(amount)
    database_connection.sql("SELECT * FROM customers LIMIT #{amount}")
  end

  def order_customers (direction)
    database_connection.sql("SELECT * FROM customers ORDER BY name #{direction}")
  end

  def id_and_name_for_customers
    database_connection.sql("SELECT id, name FROM customers")
  end

  def all_items
    database_connection.sql("SELECT * from items")
  end

  def find_item_by_name(name)

    database_connection.sql("SELECT * FROM items WHERE name = '#{name}'").first
  end

  def count_customers
    suffix(database_connection.sql("SELECT COUNT(*) AS total FROM customers"))
  end

  def sum_order_amounts
    suffix(database_connection.sql("SELECT round(SUM(amount),2) AS total FROM orders"))
  end

  def minimum_order_amount_for_customers
    database_connection.sql("SELECT customer_id, MIN(amount) FROM orders GROUP BY customer_id")
  end

  def customer_order_totals
    string = <<-BLAH
      SELECT
      customers.name,
      customers.id customer_id,
      SUM(amount)
      FROM
      orders
      JOIN customers ON orders.customer_id = customers.id
      GROUP BY customers.id
      ORDER  BY customers.id
    BLAH
    database_connection.sql(string)
  end

  def items_ordered_by_user(customer_id)
    string = <<-BLAH
      SELECT
    items.name
    FROM
    orders
    JOIN orderitems ON orders .id = orderitems.order_id
    JOIN items ON items .id = orderitems.item_id
    WHERE orders.customer_id = #{customer_id}
    BLAH

    database_connection.sql(string).map { |item| item["name"] }
  end

  def customers_that_bought_item(item)
    string = <<-BLAH
    SELECT
customers.name customer_name,
customers.id
FROM
items
JOIN orderitems ON items .id = orderitems.item_id
JOIN orders ON orderitems .order_id = orders.id
JOIN customers ON orders .customer_id=customers.id
WHERE items.name='#{item}'
GROUP BY customers.id
    BLAH

    database_connection.sql(string)

  end

end
