import os
import sys

def fibonacci(n):
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    else:
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        return b

if __name__ == "__main__":
    # Get the input number from environment variable or command-line argument
    n = int(os.getenv("FIBONACCI_NUMBER", 0))  # Default to 0 if not provided
    if len(sys.argv) > 1:
        n = int(sys.argv[1])
    
    print(f"The {n}th Fibonacci number is: {fibonacci(n)}")