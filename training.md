# Mastering Modern Java: From Functional to Advanced (Java 8 to 21) - Enhanced Edition

This comprehensive training is designed for developers with some existing Java knowledge who are ready to embrace the modern, expressive, and powerful features introduced from Java 8 up to Java 21. Each module is crafted to be a deep dive into a core concept, complete with detailed explanations, best practices, and multiple hands-on code examples.

---

## Module 1: Functional Interfaces & Lambdas (Java 8+)
**Goal:** Transition from verbose anonymous inner classes to concise, readable, and functional code. This is the foundational skill for modern Java.

### 1.1 What is a Functional Interface?
A functional interface is any interface that has **exactly one abstract method**. This constraint allows it to be the target for a lambda expression or a method reference. The `@FunctionalInterface` annotation is optional but recommended, as it tells the compiler to enforce this rule.

### 1.2 The "Core Four" Functional Interfaces: A Deep Dive
These four interfaces are the bread and butter of functional programming in Java.

#### 1. **`Predicate<T>`**:
*   **Signature**: `boolean test(T t)`
*   **Purpose**: To test a condition. Think of it as a "filter" or a "matcher."
*   **Example**: From Anonymous Class to Lambda
    ```java
    // Before: Anonymous Class
    Predicate<String> isLong = new Predicate<String>() {
        @Override
        public boolean test(String s) {
            return s.length() > 10;
        }
    };

    // After: Lambda Expression
    Predicate<String> isLongLambda = s -> s.length() > 10;
    System.out.println("Is 'hello' a long string? " + isLongLambda.test("hello")); // false
    System.out.println("Is 'introduction' a long string? " + isLongLambda.test("introduction")); // true
    ```

#### 2. **`Function<T, R>`**:
*   **Signature**: `R apply(T t)`
*   **Purpose**: To transform data. It takes an object of type `T` and returns an object of type `R`.
*   **Example**: From Anonymous Class to Lambda
    ```java
    // Before: Anonymous Class
    Function<String, Integer> getLength = new Function<String, Integer>() {
        @Override
        public Integer apply(String s) {
            return s.length();
        }
    };

    // After: Lambda Expression
    Function<String, Integer> getLengthLambda = s -> s.length();
    System.out.println("Length of 'world': " + getLengthLambda.apply("world")); // 5
    ```

#### 3. **`Consumer<T>`**:
*   **Signature**: `void accept(T t)`
*   **Purpose**: To perform an action with an object without returning anything (a "side effect").
*   **Example**: From Anonymous Class to Lambda
    ```java
    // Before: Anonymous Class
    Consumer<String> printUpperCase = new Consumer<String>() {
        @Override
        public void accept(String s) {
            System.out.println(s.toUpperCase());
        }
    };

    // After: Lambda Expression
    Consumer<String> printUpperCaseLambda = s -> System.out.println(s.toUpperCase());
    printUpperCaseLambda.accept("hello world"); // HELLO WORLD
    ```

#### 4. **`Supplier<T>`**:
*   **Signature**: `T get()`
*   **Purpose**: To produce or provide a value without taking any input. Think of it as a "factory."
*   **Example**: From Anonymous Class to Lambda
    ```java
    // Before: Anonymous Class
    Supplier<String> greeting = new Supplier<String>() {
        @Override
        public String get() {
            return "Hello from Supplier!";
        }
    };

    // After: Lambda Expression
    Supplier<String> greetingLambda = () -> "Hello from Supplier!";
    System.out.println(greetingLambda.get());
    ```

### 1.3 Method References (`::`)
Method references are a shorthand for lambdas that simply call an existing method. They make code even more readable by focusing on the method's name.

*   **Static method reference**: `ClassName::staticMethodName`
*   **Instance method reference on a particular object**: `instance::instanceMethodName`
*   **Instance method reference on an arbitrary object of a particular type**: `ClassName::instanceMethodName`
*   **Constructor reference**: `ClassName::new`

```java
public class MethodReferenceLab {
    public static void main(String[] args) {
        List<String> names = List.of("anna", "bob", "charlie");

        // Lambda: s -> System.out.println(s)
        // Method Reference:
        names.forEach(System.out::println);

        // Lambda: s -> s.toUpperCase()
        // Method Reference:
        List<String> upperCaseNames = names.stream()
            .map(String::toUpperCase)
            .collect(Collectors.toList());
        System.out.println(upperCaseNames); // [ANNA, BOB, CHARLIE]
    }
}
```

---

## Module 2: The Stream API - Mastering Data Pipelines (Java 8+)
**Goal**: Shift your mindset from imperative loops ("how to do it") to declarative pipelines ("what to do").

### 2.1 Lazy vs. Eager: The Core of Stream Performance
Intermediate operations are **lazy**. They don't do any work until a terminal operation is called. This allows the JVM to optimize the work by combining operations.

**Example: Demonstrating Laziness**
```java
import java.util.List;
import java.util.stream.Stream;

public class LazyStreamLab {
    public static void main(String[] args) {
        List<String> names = List.of("Alice", "Bob", "Charlie", "David");

        System.out.println("Defining the stream...");
        Stream<String> stream = names.stream()
            .peek(name -> System.out.println("Peeking at: " + name)) // `peek` is great for debugging streams
            .filter(name -> name.length() > 4);

        System.out.println("Stream defined, but no output yet because no terminal operation was called.");
        System.out.println("\nCalling terminal operation `findFirst()`...");

        // The work happens ONLY when the terminal operation is called
        stream.findFirst();

        // Notice how "Bob" and "David" are never peeked at. The stream stops as soon as it finds a result.
    }
}
```

### 2.2 More Stream Operations

#### Key Intermediate Operations:
*   **`filter(Predicate<T>)`**: Excludes elements that don't match the predicate.
*   **`map(Function<T,R>)`**: Transforms each element.
*   **`flatMap(Function<T, Stream<R>>)`**: Transforms each element into a stream of other elements and flattens the result.
*   **`distinct()`**: Returns a stream with unique elements.
*   **`sorted()`**: Sorts the elements.
*   **`limit(long)`**: Truncates the stream to be no longer than the given size.
*   **`skip(long)`**: Discards the first N elements of the stream.

#### Key Terminal Operations:
*   **`forEach(Consumer<T>)`**: Performs an action for each element.
*   **`collect(Collector)`**: Gathers the stream elements into a collection (e.g., `List`, `Map`, `Set`).
*   **`reduce(identity, BinaryOperator)`**: Combines stream elements into a single value.
*   **`anyMatch(Predicate)` / `allMatch(Predicate)` / `noneMatch(Predicate)`**: Checks if any/all/none elements match.
*   **`findFirst()` / `findAny()`**: Returns an `Optional` of the first/any element.

### 2.3 Advanced Collectors
The `Collectors` class is incredibly powerful.

**Example: Grouping and Partitioning**
```java
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public record Employee(String name, String department, int salary) {}

public class CollectorLab {
    public static void main(String[] args) {
        List<Employee> employees = List.of(
            new Employee("Alice", "Engineering", 120000),
            new Employee("Bob", "Engineering", 110000),
            new Employee("Charlie", "HR", 90000),
            new Employee("Diana", "HR", 95000),
            new Employee("Eve", "Sales", 80000)
        );

        // Grouping: Create a map of department -> list of employees
        Map<String, List<Employee>> byDept = employees.stream()
            .collect(Collectors.groupingBy(Employee::department));
        System.out.println("Employees by department: " + byDept);

        // Partitioning: Split employees into two groups based on a predicate
        Map<Boolean, List<Employee>> highEarners = employees.stream()
            .collect(Collectors.partitioningBy(e -> e.salary() > 100000));
        System.out.println("\nHigh earners (true) vs. others (false): " + highEarners);
    }
}
```

---

## Module 3: Modern Data Modeling (Java 14-21)
**Goal**: Eliminate boilerplate code and create clear, robust, and immutable data models.

### 3.1 Records (Java 16+): More Than Just Boilerplate
A `record` is a transparent, immutable data carrier class. Its primary benefit is immutability, which makes your data structures safer in concurrent environments and easier to reason about.

You can also add custom methods, compact constructors for validation, and even implement interfaces.

**Example: Record with Validation**
```java
public record PositiveAmount(int value) {
    // Compact constructor for validation
    public PositiveAmount {
        if (value < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
    }

    // Custom instance method
    public PositiveAmount add(PositiveAmount other) {
        return new PositiveAmount(this.value + other.value);
    }
}

public class RecordLab {
    public static void main(String[] args) {
        PositiveAmount p1 = new PositiveAmount(100);
        PositiveAmount p2 = new PositiveAmount(50);
        System.out.println("Sum: " + p1.add(p2).value()); // Sum: 150

        // This will throw an exception
        try {
            new PositiveAmount(-10);
        } catch (IllegalArgumentException e) {
            System.out.println("Caught expected exception: " + e.getMessage());
        }
    }
}
```

### 3.2 Sealed Classes (Java 17+) & Pattern Matching (Java 21+)
**Sealed Classes** allow you to define a *closed* and *finite* class hierarchy. This is a powerful modeling tool for representing fixed sets of possibilities, like states in a state machine or different kinds of events.

**Pattern Matching** has evolved significantly. With Java 21, you can use it in `switch` statements and even include `when` clauses for more complex conditions.

**Example: Advanced Pattern Matching with Guards**
```java
// Sealed interface remains the same
public sealed interface ApiResult permits Success, Failure {}
public record Success(String data) implements ApiResult {}
public record Failure(int errorCode, String message) implements ApiResult {}

public class AdvancedPatternLab {
    public static String handleResult(ApiResult result) {
        return switch (result) {
            // Pattern with a 'when' clause (guard)
            case Success s when s.data().contains("error") -> "Success contained an error message: " + s.data();
            case Success s -> "Data received: " + s.data();
            case Failure f when f.errorCode() == 404 -> "Resource not found.";
            case Failure f -> "Generic failure. Code: " + f.errorCode();
        };
    }

    public static void main(String[] args) {
        System.out.println(handleResult(new Success("{\"name\":\"John\"}")));
        System.out.println(handleResult(new Success("{\"status\":\"error\", \"msg\":\"timeout\"}")));
        System.out.println(handleResult(new Failure(404, "Not Found")));
        System.out.println(handleResult(new Failure(500, "Server Error")));
    }
}
```
---

## Module 4: High-Performance Concurrency (Java 21)
**Goal**: Understand and leverage Virtual Threads to write simple, scalable, and maintainable concurrent code.

### 4.1 How Virtual Threads Work: The "Unmounting" Concept
The magic of virtual threads is how they handle blocking I/O (e.g., waiting for a network response).

1.  A virtual thread runs on a "carrier" platform thread.
2.  When the virtual thread hits a blocking operation (like `Thread.sleep` or a network read), it **unmounts** from the carrier thread.
3.  The carrier thread is now free to run another virtual thread.
4.  Once the blocking operation is complete (e.g., data arrives from the network), the virtual thread becomes eligible to be **mounted** back onto any available carrier thread to continue its work.

This is why you can have millions of virtual threads. They only consume an OS thread when they are actively doing CPU work.

### 4.2 Structured Concurrency
Java 21 also previewed `StructuredTaskScope`, a powerful construct for managing the lifecycle of concurrent tasks. It ensures that if a task spawns multiple sub-tasks, it doesn't return until all of them have completed (either successfully or with an error). This prevents threads from leaking and makes concurrent code much easier to reason about.

**Example: Using `StructuredTaskScope` for Concurrent Fetches**
```java
import java.util.concurrent.Future;
import java.util.concurrent.StructuredTaskScope;
import java.time.Duration;

public class StructuredConcurrencyLab {
    public static void main(String[] args) throws Exception {
        try (var scope = new StructuredTaskScope.ShutdownOnFailure()) {
            // Fork two concurrent tasks
            Future<String> userFuture = scope.fork(() -> fetchUser());
            Future<String> orderFuture = scope.fork(() -> fetchOrder());

            // Wait for both to complete
            scope.join();
            scope.throwIfFailed(); // Throws an exception if any task failed

            // Combine results
            String user = userFuture.resultNow();
            String order = orderFuture.resultNow();
            System.out.println("Combined Result: " + user + " | " + order);
        }
    }

    static String fetchUser() throws InterruptedException {
        System.out.println("Fetching user...");
        Thread.sleep(Duration.ofSeconds(1));
        return "User(name=Alex)";
    }

    static String fetchOrder() throws InterruptedException {
        System.out.println("Fetching order...");
        Thread.sleep(Duration.ofSeconds(2));
        return "Order(id=123)";
    }
}
```

---

## 🏆 Final Master Challenge (Enhanced)
**Scenario**: You are building a notification system. Create a `Notification` record with fields for `user` (String), `message` (String), and `isUrgent` (boolean).

**Your task is to:**
1.  Create a list of `Notification` objects.
2.  Use a **Stream** to partition the notifications into urgent and non-urgent.
3.  For the urgent notifications, group them by user.
4.  Use a **Virtual Thread Executor** to submit a task for each user's list of urgent messages, printing them to the console.

### Solution
```java
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;
import java.time.Duration;

public record Notification(String user, String message, boolean isUrgent) {}

public class MasterChallenge {
    public static void main(String[] args) {
        List<Notification> notifications = List.of(
            new Notification("user1", "Package shipped.", false),
            new Notification("user2", "Security alert: new login.", true),
            new Notification("user1", "Your subscription is ending.", true),
            new Notification("user3", "Weekly newsletter.", false),
            new Notification("user2", "Your invoice is ready.", true)
        );

        // Partition into urgent and non-urgent
        Map<Boolean, List<Notification>> partitioned = notifications.stream()
            .collect(Collectors.partitioningBy(Notification::isUrgent));

        List<Notification> urgentNotifications = partitioned.get(true);

        // Group urgent notifications by user
        Map<String, List<Notification>> urgentByUser = urgentNotifications.stream()
            .collect(Collectors.groupingBy(Notification::user));

        System.out.println("Processing urgent notifications...");
        try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
            urgentByUser.forEach((user, userNotifications) -> {
                executor.submit(() -> {
                    System.out.printf("--- Sending %d urgent notifications to %s on %s ---\n",
                        userNotifications.size(), user, Thread.currentThread());
                    userNotifications.forEach(n -> {
                        try {
                            Thread.sleep(Duration.ofMillis(500));
                            System.out.printf("  -> SENT to %s: %s\n", user, n.message().toUpperCase());
                        } catch (InterruptedException e) {}
                    });
                });
            });
        }
    }
}
```

---

## 💥 30-Minute Advanced Stream & Lambda Challenge

**Goal**: Put your advanced stream-processing skills to the test. This challenge involves a realistic e-commerce dataset and requires you to perform complex queries and transformations.

### Setup
Copy the following code into a new Java file (e.g., `EcommerceChallenge.java`). This provides the data models and sample data for the challenge.

```java
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

public class EcommerceChallenge {

    public record Customer(long id, String name, int tier) {}
    public record Product(long id, String name, String category, double price) {}
    public record Order(long id, LocalDate orderDate, LocalDate deliveryDate, String status, long customerId, Set<Product> products) {}

    public static void main(String[] args) {
        // --- Test Data ---
        Customer cust1 = new Customer(1L, "Alice", 1);
        Customer cust2 = new Customer(2L, "Bob", 2);
        Customer cust3 = new Customer(3L, "Charlie", 1);

        Product prod1 = new Product(101L, "Laptop", "Electronics", 1200.00);
        Product prod2 = new Product(102L, "Desk Chair", "Furniture", 350.50);
        Product prod3 = new Product(103L, "Java 8 in Action", "Books", 45.99);
        Product prod4 = new Product(104L, "Monitor", "Electronics", 499.99);
        Product prod5 = new Product(105L, "Clean Code", "Books", 38.99);

        Order order1 = new Order(1001L, LocalDate.of(2023, 10, 15), LocalDate.of(2023, 10, 20), "DELIVERED", 1L, Set.of(prod1, prod3));
        Order order2 = new Order(1002L, LocalDate.of(2023, 11, 1), LocalDate.of(2023, 11, 5), "PROCESSING", 2L, Set.of(prod2, prod4));
        Order order3 = new Order(1003L, LocalDate.of(2023, 10, 28), LocalDate.of(2023, 11, 2), "DELIVERED", 1L, Set.of(prod3, prod5));
        Order order4 = new Order(1004L, LocalDate.of(2023, 11, 3), LocalDate.of(2023, 11, 6), "SHIPPED", 3L, Set.of(prod5));

        List<Customer> customers = List.of(cust1, cust2, cust3);
        List<Product> products = List.of(prod1, prod2, prod3, prod4, prod5);
        List<Order> orders = List.of(order1, order2, order3, order4);

        // --- Your Tasks Go Here ---
    }
}
```

### Your Tasks

Solve the following problems by writing stream pipelines inside the `main` method.

**Task 1: Filtering & Counting**
*   **Goal**: Find how many products belong to the "Books" category.
*   **Print**: The final count.

**Task 2: Finding the "Last" Element**
*   **Goal**: Find the most recently placed order.
*   **Print**: The `Optional<Order>`.

**Task 3: Advanced Filtering and `Optional` Handling**
*   **Goal**: Get the order with `id = 1002` and print its status, or print "Order not found" if it doesn't exist.
*   **Print**: The order status string or the "not found" message.

**Task 4: Complex Transformation (`flatMap`) and Distinct Elements**
*   **Goal**: Get a list of all unique products that have been ordered by Tier 1 customers.
*   **Print**: The `List<Product>`.

**Task 5: List to Map Conversion**
*   **Goal**: Create a `Map` where the key is the `orderId` and the value is the list of products in that order.
*   **Print**: The resulting `Map`.

**Task 6: Custom Sorting with `Comparator`**
*   **Goal**: Get a list of all products, sorted by category alphabetically (A-Z), and then by price descending (highest to lowest) within each category.
*   **Print**: The sorted `List<Product>`.

---

### Challenge Corrections

Here are the solutions to the tasks. Try to solve them yourself before looking!

```java
// Paste these solutions inside the main method of your EcommerceChallenge class

// --- Task 1 Solution ---
System.out.println("\n--- Task 1: Count Books ---");
long bookCount = products.stream()
    .filter(p -> "Books".equals(p.category()))
    .count();
System.out.println("Number of books: " + bookCount);

// --- Task 2 Solution ---
System.out.println("\n--- Task 2: Most Recent Order ---");
Optional<Order> mostRecentOrder = orders.stream()
    .max(Comparator.comparing(Order::orderDate));
System.out.println("Most recent order: " + mostRecentOrder);

// --- Task 3 Solution ---
System.out.println("\n--- Task 3: Find Order and Handle Optional ---");
String orderStatus = orders.stream()
    .filter(o -> o.id() == 1002L)
    .findFirst()
    .map(Order::status)
    .orElse("Order not found");
System.out.println("Status for order 1002: " + orderStatus);

// --- Task 4 Solution ---
System.out.println("\n--- Task 4: Products for Tier 1 Customers ---");
// First, get the IDs of Tier 1 customers
Set<Long> tier1CustomerIds = customers.stream()
    .filter(c -> c.tier() == 1)
    .map(Customer::id)
    .collect(Collectors.toSet());

List<Product> tier1Products = orders.stream()
    .filter(o -> tier1CustomerIds.contains(o.customerId())) // Filter orders from Tier 1 customers
    .flatMap(o -> o.products().stream())                   // Flatten the sets of products into one stream
    .distinct()                                            // Get only unique products
    .collect(Collectors.toList());
System.out.println("Products bought by Tier 1 customers: " + tier1Products);

// --- Task 5 Solution ---
System.out.println("\n--- Task 5: Order ID to Products Map ---");
Map<Long, Set<Product>> orderProductMap = orders.stream()
    .collect(Collectors.toMap(Order::id, Order::products));
System.out.println("Order to products map: " + orderProductMap);

// --- Task 6 Solution ---
System.out.println("\n--- Task 6: Custom Product Sort ---");
List<Product> sortedProducts = products.stream()
    .sorted(
        Comparator.comparing(Product::category) // Primary sort: category ascending
                  .thenComparing(Product::price, Comparator.reverseOrder()) // Secondary sort: price descending
    )
    .collect(Collectors.toList());
System.out.println("Sorted products: ");
sortedProducts.forEach(p -> System.out.println("  " + p));
```