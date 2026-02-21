#!/bin/bash

read -p "Enter a number: " num
read -p "Enter b number: " num2

echo "The sum of $num and $num2 is: $((num + num2))"

echo "If Condition:"

if [ $num -gt $num2 ]; then
    echo "$num is greater than $num2"
elif [ $num -lt $num2 ]; then
    echo "$num is less than $num2"
else
    echo "$num is equal to $num2"
fi

echo "For Loop:"

for i in {1..10}; do
    echo "Iteration $i"
done

echo "While Loop:"

while [ $num -gt 0 ]; do
    echo "Countdown: $num"
    num=$((num - 1 ))
done

function greet {
    echo "Hello, $1 $2 $3!"
}

greet "World" "Developer" "User"

function factorial {
    if [ $1 -le 1 ]; then
        echo 1
    else
        local temp=$(( $1 -1))
        local result=$(factorial $temp)
        echo $(( $1 * result ))
    fi
}

factorial 5