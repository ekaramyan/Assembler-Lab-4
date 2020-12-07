Chinik segment para 'code'
assume cs:Chinik,ds:Chinik,ss:Chinik,es:Chinik
org 100h ; пропускаем первые 256 байт (.com)
begin: jmp main
; это мои данные (переменные)
;---------------------------------
date dw ?
my_s db '+'
T_Th db ?
Th db ?
Hu db ?
Tens db ?
Ones db ?
;---------------------------------
A dw 50
B dw 20
Z1 dw ?
Z2 dw ?
Z3 dw ?
Y dw ?

A1 dw -40
A2 dw 10
Y1 dw ?
Y2 dw ?

adres dw ?

main proc near

;----------------1
mov ax,A
add ax,B 
mov Z1, ax
push Z1 

mov ax,A
sub ax,B
mov Z2, ax
push Z2 

mov ax,A
add ax,B 
mov bl, -1
imul bl
mov Z3, ax
push Z3

call myproc1 
pop ax 
mov date,ax
call disp
;----------------2
mov ax,A1
add ax,A2
cwd
mov bx,10
idiv bx
mov Y1,ax
push Y1 
call myproc2
pop ax 
mov date,ax
call disp

ret
main endp
;------------------------------------------
myproc1 proc near
pop adres 
pop Z3
pop Z2
pop Z1 

cmp Z1, 1
jge m1 ; если больше или равно 1, то уходим на метку m1
cmp Z2, 1
jge m2 ; если больше или равно 1, то уходим на метку m2
cmp Z3, 1
jge m3 ; если больше или равно 1, то уходим на метку m3

jl m4 ; если меньше 1, то уходим на метку m4

m1:
mov Y, 0
jmp konec
m2:
mov Y, 1
jmp konec
m3:
mov Y, 2
jmp konec
m4:
mov Y, 3
jmp konec

konec: push Y 
push adres 
ret
myproc1 endp
;------------------------------------------
myproc2 proc near
pop adres
pop Y1 

cmp Y1, 0
jg m5 ; если больше 0, то уходим на метку z1
mov Y2, 221 ; DD
jmp konecc

m5: 
mov Y2, 255 ; FF 
jmp konecc

konecc: push Y2
push adres
ret
myproc2 endp
;------------------------------------------

; Процедура выводит результат вычислений, помещенный в data
DISP proc near
;----- Вывод результата на экран ----------------
;--- Число отрицательное ?----------
mov ax,date
and ax,1000000000000000b
mov cl,15
shr ax,cl
cmp ax,1
jne @m1
mov ax,date
neg ax
mov my_s,'-'
jmp @m2
;--- Получаем десятки тысяч ---------------
@m1: mov ax,date
@m2: cwd
mov bx,10000
idiv bx
mov T_Th,al
;------- Получаем тысячи ------------------------------
mov ax,dx

cwd
mov bx,1000
idiv bx
mov Th,al
;------ Получаем сотни ---------------
mov ax,dx
mov bl,100
idiv bl
mov Hu,al
;---- Получаем десятки и единицы ----------------------
mov al,ah
cbw
mov bl,10
idiv bl
mov Tens,al
mov Ones,ah
;--- Выводим знак -----------------------
cmp my_s,'+'
je @m500
mov ah,02h
mov dl,my_s
int 21h
;---------- Выводим цифры -----------------
@m500: cmp T_TH,0 ; проверка на ноль
je @m200
mov ah,02h ; выводим на экран, если не ноль
mov dl,T_Th
add dl,48
int 21h
@m200: cmp T_Th,0
jne @m300
cmp Th,0
je @m400
@m300: mov ah,02h
mov dl,Th
add dl,48
int 21h
@m400: cmp T_TH,0
jne @m600
cmp Th,0
jne @m600
cmp hu,0
je @m700
@m600: mov ah,02h
mov dl,Hu

add dl,48
int 21h
@m700: cmp T_TH,0
jne @m900
cmp Th,0
jne @m900
cmp Hu,0
jne @m900
cmp Tens,0
je @m950
@m900: mov ah,02h
mov dl,Tens
add dl,48
int 21h
@m950: mov ah,02h
mov dl,Ones
add dl,48
int 21h
mov ah,02h
mov dl,10
int 21h
mov ah,02h
mov dl,13
int 21h
;-------------------------------------
mov ah,08
int 21h
ret
DISP endp

Chinik ends
end begin
