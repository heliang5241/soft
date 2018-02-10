#!/bin/bash
fangfa1(){
	sum=0
	for i in {1..100}; do
		let sum+=$i
	done
	echo $sum
}
fangfa2(){
	sum=0
	for i in {1..100..1}; do
    	let sum+=$i
	done
	echo $sum
}
fangfa3(){
	sum=0
	for((i=0;i<=100;i++)); do
		let sum+=$i
	done
	echo $sum
}
fangfa4(){
	sum=0
	i=0
	while [[ $i -le 100 ]]; do
		let sum+=$i
		let i++
	done
	echo $sum
}
fangfa5(){
	sum=0
	i=0
	until [[ $i -gt 100 ]]; do
		let sum+=$i
		let i++
	done
	echo $sum
}
fangfa5
