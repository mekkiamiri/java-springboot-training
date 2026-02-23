# Mastering Modern Java: From Functional to Advanced (Java 8 to 25) - Enhanced Edition

This comprehensive training is designed for developers with some existing Java knowledge who are ready to embrace the modern, expressive, and powerful features introduced from Java 8 up to Java 25 (LTS). Each module is crafted to be a deep dive into a core concept, complete with detailed explanations, best practices, and multiple hands-on code examples.

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

### 2.2 Key Stream Operations

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
*   **`toList()`** (Java 16+): Shorthand for `.collect(Collectors.toList())`. Returns an **unmodifiable** list.
*   **`reduce(identity, BinaryOperator)`**: Combines stream elements into a single value.
*   **`anyMatch(Predicate)` / `allMatch(Predicate)` / `noneMatch(Predicate)`**: Checks if any/all/none elements match.
*   **`findFirst()` / `findAny()`**: Returns an `Optional` of the first/any element.

> **Note on `toList()` vs `Collectors.toList()`**: Since Java 16, you can use `.toList()` directly on a stream. It's shorter, but the returned list is **unmodifiable** (you cannot add/remove elements). Use `Collectors.toList()` if you need a mutable list.

### 2.3 Deep Dive: `flatMap` - Flattening Nested Structures
`flatMap` is one of the most powerful and often misunderstood operations. It solves the problem of nested collections by merging multiple streams into one.

**Example: Extracting tags from blog posts**
```java
import java.util.List;
import java.util.stream.Collectors;

public class FlatMapLab {

    public record BlogPost(String title, List<String> tags) {}

    public static void main(String[] args) {
        List<BlogPost> posts = List.of(
            new BlogPost("Java Streams Guide", List.of("java", "streams", "functional")),
            new BlogPost("Spring Boot Tips", List.of("java", "spring", "backend")),
            new BlogPost("React with Java", List.of("react", "java", "fullstack"))
        );

        // Problem: map() gives us Stream<List<String>> - a stream of lists!
        // We want a flat Stream<String> of all tags.

        // Using flatMap to flatten all tag lists into a single stream of tags
        List<String> allUniqueTags = posts.stream()
            .flatMap(post -> post.tags().stream()) // Each List<String> becomes a Stream<String>, then all are merged
            .distinct()
            .sorted()
            .toList(); // Java 16+ shorthand

        System.out.println("All unique tags: " + allUniqueTags);
        // [backend, fullstack, functional, java, react, spring, streams]
    }
}
```

### 2.4 Deep Dive: `reduce` - Combining Elements Into a Single Result
`reduce` is a terminal operation that combines all elements of a stream into a single value by repeatedly applying a combining function.

**Example: Computing totals and building strings**
```java
import java.util.List;
import java.util.Optional;

public class ReduceLab {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5);

        // reduce with identity value: always returns a value
        int sum = numbers.stream()
            .reduce(0, Integer::sum); // identity=0, accumulator=Integer::sum
        System.out.println("Sum: " + sum); // 15

        int product = numbers.stream()
            .reduce(1, (a, b) -> a * b);
        System.out.println("Product: " + product); // 120

        // reduce without identity: returns Optional (stream might be empty)
        Optional<Integer> max = numbers.stream()
            .reduce(Integer::max);
        max.ifPresent(m -> System.out.println("Max: " + m)); // 5

        // Real-world example: building a comma-separated string
        List<String> words = List.of("Java", "is", "awesome");
        String sentence = words.stream()
            .reduce((a, b) -> a + " " + b)
            .orElse("");
        System.out.println("Sentence: " + sentence); // Java is awesome

        // Tip: For string joining, prefer Collectors.joining() - it's optimized with StringBuilder
        String betterSentence = words.stream()
            .collect(java.util.stream.Collectors.joining(" "));
        System.out.println("Better: " + betterSentence); // Java is awesome
    }
}
```

### 2.5 Advanced Collectors
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

        // Downstream collector: department -> average salary
        Map<String, Double> avgSalaryByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::department,
                Collectors.averagingInt(Employee::salary)
            ));
        System.out.println("Average salary by dept: " + avgSalaryByDept);

        // Partitioning: Split employees into two groups based on a predicate
        Map<Boolean, List<Employee>> highEarners = employees.stream()
            .collect(Collectors.partitioningBy(e -> e.salary() > 100000));
        System.out.println("\nHigh earners (true) vs. others (false): " + highEarners);
    }
}
```

---

## Module 3: Modern Data Modeling (Java 14-25)
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

### 3.3 Combining Streams with Pattern Matching
Sealed classes and streams work great together. Here's a real-world pattern: processing a list of heterogeneous results.

**Example: Processing a batch of API results**
```java
import java.util.List;
import java.util.stream.Collectors;

public class StreamPatternLab {
    sealed interface ApiResult permits Success, Failure {}
    record Success(String data) implements ApiResult {}
    record Failure(int errorCode, String message) implements ApiResult {}

    public static void main(String[] args) {
        List<ApiResult> results = List.of(
            new Success("user-1"),
            new Failure(404, "user-2 not found"),
            new Success("user-3"),
            new Failure(500, "server error"),
            new Success("user-4")
        );

        // Extract only successful data
        List<String> successData = results.stream()
            .filter(r -> r instanceof Success)
            .map(r -> ((Success) r).data())
            .toList();
        System.out.println("Successes: " + successData); // [user-1, user-3, user-4]

        // With Java 21 pattern matching in instanceof + map
        // Count errors by error code
        var errorSummary = results.stream()
            .filter(r -> r instanceof Failure)
            .map(r -> (Failure) r)
            .collect(Collectors.groupingBy(Failure::errorCode, Collectors.counting()));
        System.out.println("Error summary: " + errorSummary); // {404=1, 500=1}

        // Produce a report using switch pattern matching
        results.stream()
            .map(r -> switch (r) {
                case Success s -> "[OK] " + s.data();
                case Failure f -> "[ERR " + f.errorCode() + "] " + f.message();
            })
            .forEach(System.out::println);
    }
}
```

---

## Module 4: High-Performance Concurrency (Java 21-24)
**Goal**: Understand and leverage Virtual Threads to write simple, scalable, and maintainable concurrent code.

> **Important**: Virtual Threads are a final feature in Java 21. However, `StructuredTaskScope` is a **preview feature** that remains in preview through Java 25 (5th preview, JEP 505). The examples below use the Java 21 preview API. You must compile and run with `--enable-preview`. The API may differ in later JDK versions.

### 4.1 How Virtual Threads Work: The "Unmounting" Concept
The magic of virtual threads is how they handle blocking I/O (e.g., waiting for a network response).

1.  A virtual thread runs on a "carrier" platform thread.
2.  When the virtual thread hits a blocking operation (like `Thread.sleep` or a network read), it **unmounts** from the carrier thread.
3.  The carrier thread is now free to run another virtual thread.
4.  Once the blocking operation is complete (e.g., data arrives from the network), the virtual thread becomes eligible to be **mounted** back onto any available carrier thread to continue its work.

This is why you can have millions of virtual threads. They only consume an OS thread when they are actively doing CPU work.

### 4.2 Virtual Threads in Practice
The simplest way to use virtual threads is with `Executors.newVirtualThreadPerTaskExecutor()`. This is a **final, stable API** in Java 21.

**Example: Comparing Platform vs Virtual Threads**
```java
import java.time.Duration;
import java.time.Instant;
import java.util.concurrent.Executors;
import java.util.stream.IntStream;

public class VirtualThreadLab {
    public static void main(String[] args) {
        Instant start = Instant.now();

        // Spawn 10,000 virtual threads, each sleeping 1 second
        try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
            IntStream.range(0, 10_000).forEach(i -> {
                executor.submit(() -> {
                    Thread.sleep(Duration.ofSeconds(1));
                    return i;
                });
            });
        } // executor.close() waits for all tasks

        Instant end = Instant.now();
        System.out.println("Completed 10,000 tasks in: " + Duration.between(start, end).toMillis() + "ms");
        // Typically ~1-2 seconds, NOT 10,000 seconds!
    }
}
```

### 4.3 Virtual Threads + `synchronized` Fix (Java 24)
Before Java 24, a virtual thread blocked inside a `synchronized` block would **pin** its carrier platform thread, preventing it from running other virtual threads. This was a major gotcha. **Java 24 (JEP 491) fixes this** — virtual threads now properly unmount even inside `synchronized`.

```java
// Before Java 24: This could cause thread starvation with virtual threads
// because synchronized pins the carrier thread.
// After Java 24: Works correctly — no code change needed.

private final Object lock = new Object();

void processRequest() {  // called on a virtual thread
    synchronized (lock) {
        // Blocking I/O inside synchronized no longer pins the carrier thread
        var result = httpClient.send(request, BodyHandlers.ofString());
        process(result);
    }
}
// Tip: On Java 21-23, prefer ReentrantLock over synchronized for virtual threads.
// On Java 24+, synchronized is fine.
```

### 4.4 Structured Concurrency (Preview)
Java 21 previewed `StructuredTaskScope`, a powerful construct for managing the lifecycle of concurrent tasks. It ensures that if a task spawns multiple sub-tasks, it doesn't return until all of them have completed (either successfully or with an error). This prevents threads from leaking and makes concurrent code much easier to reason about.

> **Preview API Notice**: Compile and run with: `javac --enable-preview --source 21 StructuredConcurrencyLab.java` and `java --enable-preview StructuredConcurrencyLab`. The API has evolved across preview rounds (JDK 21-25) — later versions use `Subtask<T>` instead of `Future<T>` and static factory methods instead of constructors. It is **not yet final** as of Java 25.

**Example: Using `StructuredTaskScope` for Concurrent Fetches (JDK 21 Preview)**
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
        System.out.println("Fetching user on " + Thread.currentThread());
        Thread.sleep(Duration.ofSeconds(1));
        return "User(name=Alex)";
    }

    static String fetchOrder() throws InterruptedException {
        System.out.println("Fetching order on " + Thread.currentThread());
        Thread.sleep(Duration.ofSeconds(2));
        return "Order(id=123)";
    }
}
```

---

## Module 5: Unnamed Variables & Markdown JavaDoc (Java 22-23)
**Goal**: Write cleaner code by discarding unused variables, and adopt modern documentation syntax.

### 5.1 Unnamed Variables and Patterns (Java 22, JEP 456)
Use the underscore `_` wherever a variable is required by syntax but never read. This eliminates "unused variable" warnings and makes intent explicit.

```java
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class UnnamedVariableLab {

    sealed interface Shape permits Circle, Rectangle, Triangle {}
    record Circle(double radius) implements Shape {}
    record Rectangle(double w, double h) implements Shape {}
    record Triangle(double base, double height) implements Shape {}

    public static void main(String[] args) {
        // In enhanced for-loops: counting without using the element
        var items = List.of("a", "b", "c");
        int count = 0;
        for (var _ : items) {
            count++;
        }
        System.out.println("Count: " + count); // 3

        // In catch blocks: you don't need the exception variable
        try {
            Integer.parseInt("not-a-number");
        } catch (NumberFormatException _) {
            System.out.println("Invalid number format");
        }

        // In lambdas: unused parameters
        Map<String, String> lookup = items.stream()
            .collect(Collectors.toMap(String::toUpperCase, _ -> "UNKNOWN"));
        System.out.println("Lookup: " + lookup);

        // In pattern matching with switch
        Shape shape = new Circle(5.0);
        String description = switch (shape) {
            case Circle _    -> "It's a circle";
            case Rectangle _ -> "It's a rectangle";
            case Triangle _  -> "It's a triangle";
        };
        System.out.println(description);
    }
}
```

### 5.2 Markdown Documentation Comments (Java 23, JEP 467)
JavaDoc can now be written in **Markdown** using `///` line comments instead of `/** ... */` with HTML. Existing HTML JavaDoc still works — this is an alternative syntax.

```java
/// Returns the greater of two `int` values.
///
/// ## Parameters
/// - **a** - the first operand
/// - **b** - the second operand
///
/// ## Example
/// ```
/// int max = MathUtils.max(3, 7); // returns 7
/// ```
///
/// @param a the first operand
/// @param b the second operand
/// @return the greater of `a` and `b`
public static int max(int a, int b) {
    return (a >= b) ? a : b;
}
```

> **Note**: The `@param`, `@return`, `@throws` tags still work inside `///` blocks. You can mix Markdown formatting with traditional JavaDoc tags.

---

## Module 6: Stream Gatherers & Scoped Values (Java 24-25)
**Goal**: Extend stream pipelines with custom intermediate operations and replace `ThreadLocal` with scoped, safer alternatives.

### 6.1 Stream Gatherers (Java 24, JEP 485)
Gatherers add a `gather()` intermediate operation to streams, enabling **custom intermediate operations** that weren't possible before. Java ships built-in gatherers in `java.util.stream.Gatherers`.

```java
import java.util.List;
import java.util.stream.Gatherers;

public class GathererLab {
    public static void main(String[] args) {
        List<String> items = List.of("A", "B", "C", "D", "E");

        // Fixed-size windows: group elements into chunks
        List<List<String>> windows = items.stream()
            .gather(Gatherers.windowFixed(3))
            .toList();
        System.out.println("Fixed windows: " + windows);
        // [[A, B, C], [D, E]]

        // Sliding windows: overlapping groups
        List<List<String>> sliding = items.stream()
            .gather(Gatherers.windowSliding(3))
            .toList();
        System.out.println("Sliding windows: " + sliding);
        // [[A, B, C], [B, C, D], [C, D, E]]

        // Scan: running accumulation (like reduce, but emits each intermediate result)
        List<Integer> transactions = List.of(1000, -200, -500, 200, -300);
        List<Integer> balanceHistory = transactions.stream()
            .gather(Gatherers.scan(() -> 0, Integer::sum))
            .toList();
        System.out.println("Balance history: " + balanceHistory);
        // [1000, 800, 300, 500, 200]

        // Fold: like reduce but as a gatherer (emits a single result)
        String concatenated = items.stream()
            .gather(Gatherers.fold(() -> "", (acc, el) -> acc + el))
            .findFirst().orElse("");
        System.out.println("Folded: " + concatenated);
        // ABCDE
    }
}
```

> **Why Gatherers matter**: Before Java 24, if you needed windowing, batching, or scan-like operations, you had to break out of the stream pipeline or use a third-party library. Gatherers make the Stream API extensible.

### 6.2 Scoped Values (Java 25, JEP 506)
`ScopedValue` is the modern, safe replacement for `ThreadLocal`. Values are **immutable**, **bounded to a scope**, and automatically cleaned up. They also work correctly with virtual threads (unlike `ThreadLocal` which can leak).

```java
import java.lang.ScopedValue;

public class ScopedValueLab {

    // Declare as static final (like a ThreadLocal, but better)
    private static final ScopedValue<String> CURRENT_USER = ScopedValue.newInstance();

    public static void main(String[] args) {
        // Bind a value and run code within that scope
        ScopedValue.where(CURRENT_USER, "alice").run(() -> {
            processOrder();
            sendConfirmation();
        });
        // CURRENT_USER is no longer bound here

        // Bind a different value for another request
        ScopedValue.where(CURRENT_USER, "bob").run(() -> {
            processOrder();
        });
    }

    static void processOrder() {
        // Any code in the call chain can read the scoped value
        String user = CURRENT_USER.get();
        System.out.println("Processing order for: " + user);
    }

    static void sendConfirmation() {
        String user = CURRENT_USER.get();
        System.out.println("Sending confirmation to: " + user);
    }
}
```

**`ScopedValue` vs `ThreadLocal`:**

| | `ThreadLocal` | `ScopedValue` |
|---|---|---|
| Mutability | Mutable (`set()` anytime) | Immutable per scope |
| Cleanup | Manual (`remove()` or leak) | Automatic when scope ends |
| Inheritance | `InheritableThreadLocal` (copies) | Works with virtual threads natively |
| Performance | HashMap per thread | Optimized for short-lived scopes |

---

## Module 7: Java 25 Language Features (Java 25 LTS)
**Goal**: Learn the three new language features that simplify everyday Java code.

### 7.1 Module Import Declarations (JEP 511)
Import all packages exported by a module with a single statement. No more long import blocks.

```java
// Instead of:
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

// You can write:
import module java.base;

public class ModuleImportLab {
    public static void main(String[] args) {
        // All java.base packages are available: java.util, java.util.stream, java.io, etc.
        List<String> names = List.of("Alice", "Bob", "Charlie");
        Map<String, Integer> nameLengths = names.stream()
            .collect(Collectors.toMap(n -> n, String::length));
        System.out.println(nameLengths);
    }
}

// Resolving ambiguities: if two modules export the same simple name,
// add a specific import to disambiguate:
// import module java.base;
// import module java.sql;
// import java.sql.Date;  // resolves Date ambiguity between java.sql and java.util
```

### 7.2 Compact Source Files & Instance Main Methods (JEP 512)
Write simple programs without `public class`, `static`, or `String[] args`. Perfect for scripts, prototypes, and teaching.

```java
// FILE: HelloWorld.java — This is a complete, valid Java 25 program.
// No class declaration, no static, no String[] args.
void main() {
    println("Hello, World!");
}
```

```java
// A more realistic example:
// FILE: QuickScript.java
void main() {
    var names = List.of("Alice", "Bob", "Charlie");
    names.stream()
        .filter(n -> n.length() > 3)
        .forEach(n -> println("Name: " + n));
}
```

> **How it works**: The launch protocol searches for `main()` methods in this order:
> 1. `static void main(String[])` — traditional
> 2. `static void main()` — no-args static
> 3. `void main(String[])` — instance with args
> 4. `void main()` — instance no-args
>
> This is backward-compatible: existing `public static void main(String[] args)` still works.

### 7.3 Flexible Constructor Bodies (JEP 513)
You can now place statements **before** `super()` or `this()` in constructors. This eliminates the common workaround of static helper methods for argument validation.

```java
public class FlexibleConstructorLab {

    static class Person {
        private final String name;
        Person(String name) { this.name = name; }
        String name() { return name; }
    }

    static class Employee extends Person {
        private final String department;

        Employee(String name, String department) {
            // Prologue: validate and transform BEFORE calling super()
            if (name == null || name.isBlank()) {
                throw new IllegalArgumentException("Name is required");
            }
            var normalizedName = name.strip().toUpperCase();

            super(normalizedName);  // now pass the computed value to super
            this.department = department;
        }
    }

    public static void main(String[] args) {
        var emp = new Employee("  alice  ", "Engineering");
        System.out.println("Name: " + emp.name());        // ALICE
        System.out.println("Dept: " + emp.department);     // Engineering

        try {
            new Employee("  ", "HR");
        } catch (IllegalArgumentException e) {
            System.out.println("Caught: " + e.getMessage()); // Name is required
        }
    }
}
```

> **Rule**: Prologue statements can validate arguments, compute values, and assign fields of the current class. They **cannot** reference `this` as an instance (e.g., no calling instance methods or passing `this` to other methods).

---

## Final Master Challenge (Enhanced)
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

## 30-Minute Advanced Stream & Lambda Challenge

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
*   **Goal**: Create a `Map` where the key is the `orderId` and the value is the `Set<Product>` in that order.
*   **Print**: The resulting `Map`.

**Task 6: Custom Sorting with `Comparator`**
*   **Goal**: Get a list of all products, sorted by category alphabetically (A-Z), and then by price descending (highest to lowest) within each category.
*   **Print**: The sorted `List<Product>`.

**Task 7: Reducing to a Total (NEW)**
*   **Goal**: Compute the total value of all products across all orders (sum of all product prices, counting duplicates across orders).
*   **Print**: The total as a `double`.

---

### Challenge Solutions

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
    .toList();                                             // Java 16+ shorthand
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
    .toList();
System.out.println("Sorted products: ");
sortedProducts.forEach(p -> System.out.println("  " + p));

// --- Task 7 Solution (NEW: reduce) ---
System.out.println("\n--- Task 7: Total Order Value using reduce ---");
double totalValue = orders.stream()
    .flatMap(o -> o.products().stream())
    .mapToDouble(Product::price)
    .reduce(0.0, Double::sum); // Could also use .sum() shorthand
System.out.println("Total value across all orders: " + totalValue);
// Alternative with .sum() shorthand:
double totalValue2 = orders.stream()
    .flatMap(o -> o.products().stream())
    .mapToDouble(Product::price)
    .sum();
System.out.println("Same result with .sum(): " + totalValue2);
```

---

## 30-Minute Modern Java Challenge (Java 22-25)

**Goal**: Practice the new language features from Java 22-25 in a realistic IoT sensor monitoring scenario. You'll use unnamed variables, stream gatherers, scoped values, flexible constructors, and module imports.

### Setup
Copy the following code into a new Java file (e.g., `SensorChallenge.java`). This provides the data models and sample data.

```java
import module java.base;

public class SensorChallenge {

    // --- Data Models ---

    sealed interface SensorReading permits Temperature, Humidity, Pressure {}
    record Temperature(String sensorId, double celsius, long timestamp) implements SensorReading {}
    record Humidity(String sensorId, double percent, long timestamp) implements SensorReading {}
    record Pressure(String sensorId, double hPa, long timestamp) implements SensorReading {}

    static class Sensor {
        private final String id;
        private final String location;

        Sensor(String id, String location) {
            // TODO (Task 5): Add validation BEFORE super() using flexible constructor bodies
            this.id = id;
            this.location = location;
        }

        String id() { return id; }
        String location() { return location; }
    }

    public static void main(String[] args) {
        // --- Test Data: 12 sensor readings over time ---
        List<SensorReading> readings = List.of(
            new Temperature("T1", 22.5, 1000), new Humidity("H1", 45.0, 1000), new Pressure("P1", 1013.25, 1000),
            new Temperature("T1", 23.1, 2000), new Humidity("H1", 47.0, 2000), new Pressure("P1", 1012.80, 2000),
            new Temperature("T1", 24.8, 3000), new Humidity("H1", 50.0, 3000), new Pressure("P1", 1011.50, 3000),
            new Temperature("T1", 26.2, 4000), new Humidity("H1", 55.0, 4000), new Pressure("P1", 1010.00, 4000)
        );

        List<Sensor> sensors = List.of(
            new Sensor("T1", "Server Room A"),
            new Sensor("H1", "Server Room A"),
            new Sensor("P1", "Rooftop")
        );

        // --- Your Tasks Go Here ---
    }
}
```

### Your Tasks

**Task 1: Classify readings using unnamed variables (Java 22)**
*   **Goal**: Print a one-line summary for each reading. You only need the type name (Temperature/Humidity/Pressure) and the value, not the variable binding.
*   **Hint**: Use `case Temperature _ ->` unnamed pattern in a switch, but you'll need the value... Think about when to use `_` and when not to.
*   **Print**: One line per reading, e.g. `"Temperature: 22.5 C"`, `"Humidity: 45.0 %"`, `"Pressure: 1013.25 hPa"`.

**Task 2: Sliding window averages with Gatherers (Java 24)**
*   **Goal**: Extract only the `Temperature` readings, then compute a **sliding window moving average** over 3 consecutive readings.
*   **Hint**: Filter to `Temperature`, extract the celsius values, use `Gatherers.windowSliding(3)`, then map each window to its average.
*   **Print**: The list of moving averages.

**Task 3: Batch readings into fixed windows (Java 24)**
*   **Goal**: Group ALL readings into **batches of 3** (the natural grouping per timestamp) using `Gatherers.windowFixed(3)`.
*   **Print**: Each batch on its own line with a label like `"Batch 1: [...]"`.

**Task 4: Running temperature delta with scan (Java 24)**
*   **Goal**: Extract the temperature celsius values and compute a **running delta** (difference from the previous reading) using `Gatherers.scan()`. The first delta should be `0.0`.
*   **Hint**: The scan state holds the previous temperature. Emit the delta at each step.
*   **Print**: The list of deltas, e.g. `[0.0, 0.6, 1.7, 1.4]`.

**Task 5: Flexible constructor validation (Java 25)**
*   **Goal**: Modify the `Sensor` constructor to validate that `id` is non-null/non-blank and `location` is non-null/non-blank **before** any field assignment. Throw `IllegalArgumentException` with a clear message. Then test it.
*   **Print**: Successful creation, then the caught exception message.

**Task 6: Scoped Values for analysis context (Java 25)**
*   **Goal**: Create a `ScopedValue<String>` called `ANALYSIS_SESSION`. Bind it to `"Session-A"` and inside the scope, call a method `analyzeReadings(readings)` that prints the session name and the count of readings. Then bind to `"Session-B"` and call it again.
*   **Print**: Two lines like `"[Session-A] Analyzing 12 readings"` and `"[Session-B] Analyzing 12 readings"`.

---

### Challenge Solutions

Try to solve them yourself before looking!

```java
import module java.base;

public class SensorChallenge {

    sealed interface SensorReading permits Temperature, Humidity, Pressure {}
    record Temperature(String sensorId, double celsius, long timestamp) implements SensorReading {}
    record Humidity(String sensorId, double percent, long timestamp) implements SensorReading {}
    record Pressure(String sensorId, double hPa, long timestamp) implements SensorReading {}

    static class Sensor {
        private final String id;
        private final String location;

        // Task 5: Flexible constructor body with validation BEFORE field assignment
        Sensor(String id, String location) {
            if (id == null || id.isBlank()) {
                throw new IllegalArgumentException("Sensor id is required");
            }
            if (location == null || location.isBlank()) {
                throw new IllegalArgumentException("Sensor location is required");
            }
            this.id = id.strip();
            this.location = location.strip();
        }

        String id() { return id; }
        String location() { return location; }
    }

    // Task 6: Scoped value
    static final ScopedValue<String> ANALYSIS_SESSION = ScopedValue.newInstance();

    public static void main(String[] args) {
        List<SensorReading> readings = List.of(
            new Temperature("T1", 22.5, 1000), new Humidity("H1", 45.0, 1000), new Pressure("P1", 1013.25, 1000),
            new Temperature("T1", 23.1, 2000), new Humidity("H1", 47.0, 2000), new Pressure("P1", 1012.80, 2000),
            new Temperature("T1", 24.8, 3000), new Humidity("H1", 50.0, 3000), new Pressure("P1", 1011.50, 3000),
            new Temperature("T1", 26.2, 4000), new Humidity("H1", 55.0, 4000), new Pressure("P1", 1010.00, 4000)
        );

        // --- Task 1: Classify with unnamed variables ---
        System.out.println("--- Task 1: Classify Readings ---");
        readings.forEach(r -> {
            String summary = switch (r) {
                case Temperature t -> "Temperature: " + t.celsius() + " C";
                case Humidity h    -> "Humidity: " + h.percent() + " %";
                case Pressure p    -> "Pressure: " + p.hPa() + " hPa";
            };
            System.out.println(summary);
        });

        // --- Task 2: Sliding window moving average ---
        System.out.println("\n--- Task 2: Sliding Window Temperature Average ---");
        List<Double> movingAvg = readings.stream()
            .filter(r -> r instanceof Temperature)
            .map(r -> ((Temperature) r).celsius())
            .gather(Gatherers.windowSliding(3))
            .map(window -> window.stream().mapToDouble(Double::doubleValue).average().orElse(0.0))
            .toList();
        System.out.println("Moving averages (window=3): " + movingAvg);
        // [23.466..., 24.7]

        // --- Task 3: Fixed window batching ---
        System.out.println("\n--- Task 3: Fixed Window Batches ---");
        var batches = readings.stream()
            .gather(Gatherers.windowFixed(3))
            .toList();
        for (int i = 0; i < batches.size(); i++) {
            System.out.println("Batch " + (i + 1) + ": " + batches.get(i));
        }

        // --- Task 4: Running delta with scan ---
        System.out.println("\n--- Task 4: Running Temperature Delta ---");
        List<Double> temps = readings.stream()
            .filter(r -> r instanceof Temperature)
            .map(r -> ((Temperature) r).celsius())
            .toList();

        List<Double> deltas = temps.stream()
            .gather(Gatherers.scan(
                () -> new double[]{0.0, Double.NaN},  // [delta, previousTemp]
                (state, temp) -> {
                    double delta = Double.isNaN(state[1]) ? 0.0 : temp - state[1];
                    return new double[]{delta, temp};
                }
            ))
            .map(state -> Math.round(state[0] * 10.0) / 10.0)  // round to 1 decimal
            .toList();
        System.out.println("Deltas: " + deltas);
        // [0.0, 0.6, 1.7, 1.4]

        // --- Task 5: Flexible constructor ---
        System.out.println("\n--- Task 5: Flexible Constructor Validation ---");
        var sensor = new Sensor("T1", "Server Room A");
        System.out.println("Created sensor: " + sensor.id() + " @ " + sensor.location());
        try {
            new Sensor("", "Rooftop");
        } catch (IllegalArgumentException e) {
            System.out.println("Caught: " + e.getMessage());
        }

        // --- Task 6: Scoped Values ---
        System.out.println("\n--- Task 6: Scoped Values ---");
        ScopedValue.where(ANALYSIS_SESSION, "Session-A").run(() -> analyzeReadings(readings));
        ScopedValue.where(ANALYSIS_SESSION, "Session-B").run(() -> analyzeReadings(readings));
    }

    static void analyzeReadings(List<SensorReading> readings) {
        String session = ANALYSIS_SESSION.get();
        System.out.println("[" + session + "] Analyzing " + readings.size() + " readings");
    }
}
```
