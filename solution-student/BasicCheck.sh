

#!/bin/bash


folderName=$1
executable=$2
currentfolder=$(pwd)

ans=7
echo "ans $ans"

Compliation="FAIL"
Memory_leaks="FAIL"
Thread_race="FAIL"

cd $folderName

if [ -f Makefile ]; then

make 2>&1
secssesfullmake=$?
echo "MAKE EXIT CODE: $secssesfullmake"

if [[ $secssesfullmake -ne 0 ]]; then
echo "HAHAHA!!"
valgrind --leak-check=full --error-exitcode=1  ./$executable "${@:2}" > /dev/null 2&>1
valgridgout=$?

valgrind --tool=helgrind --error-exitcode=1 ./$executable "${@:2}"> /dev/null 2&>1
helgrindout=$?



   if [[ $valgridgout -ne 1 && $helgrindout -ne 1 ]]; then
    Compliation="PASS"
    Memory_leaks="PASS"
    Thread_race="PASS"
    ans=0
   

   elif [[ $valgridgout -eq 1 && $helgrindout -ne 1 ]]; then
    Compliation="PASS"
    Memory_leaks="FAIL"
    Thread_race="PASS"
    ans=2
   

   elif [[ $valgridgout -ne 1 && $helgrindout -eq 1 ]]; then
    Compliation="PASS"
    Memory_leaks="PASS"
    Thread_race="FAIL"
    ans=1
   

   elif [[ $valgridgout -eq 1 && $helgrindout -eq 1 ]]; then
    Compliation="PASS"
    Memory_leaks="FAIL"
    Thread_race="FAIL"
    ans=3
   
  fi

 fi
fi
cd $currentfolder
echo "Compilation| Memory leaks| thread race" 
echo "    "$Compliation"   |     "$Memory_leaks"    |     "$Thread_race"   " 
echo "secssesfullmake $secssesfullmake"
echo "ans $ans"
exit $ans



