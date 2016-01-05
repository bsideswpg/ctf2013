[BITS 16]
[ORG 0x7C00]

jmp start

hello db "gl hf", 13, 10, "# ", 0 ; The starting message
rmchar db 8,' ',8, 0 ; Emulates pressing backspace
win db 13, 10, "Win!", 0
lose db 13, 10, "Lose!", 0

%macro biosprint 1 ; A nice wrapper
mov si, %1
call puts
%endmacro

; print a string - expects that SI is pointing at our string
puts:
  lodsb
  cmp BYTE al, 0
  je puts_end
    call putc
    jmp puts
  puts_end:
    ret

; print a char to screen - used by puts
putc:
  mov ah, 0x0E
  mov bx, 0x11
  int 0x10
  ret

start:
xor ax, ax ; we just want to use absolute addresses
mov ds, ax
mov es, ax

biosprint hello

mov bp, 0x7E00; ; this is where we write our password, and will become the sector we write back
keep_zeroing:
  mov [bp], BYTE 0x00
  inc bp
  cmp bp, 0x8000 ; 512 bytes from 0x7E00
  jb keep_zeroing

mov di, 0x7E00 ; read the user's password into memory at 0x7E00
xor cx, cx ; we start out at zero characters

readchar:
  mov ah, 0x00 ; get a character
  int 0x16
  cmp al, 13 ; ASCII code 13 is the 'Enter' key on my keyboard
  je readchar_end
  cmp al, 8  ; ASCII code 8 is the 'Backspace' key on my keyboard
  je backspace
  stosb
  call putc
  inc cx
  jmp readchar

backspace:
  test cx, cx
  je readchar ; don't keep backing up if there are no characters entered
  biosprint rmchar
  dec di
  mov [di], BYTE 0x00 ; blank a character from memory, remove one character from screen
  dec cx
  jmp readchar

readchar_end: ; we get here when the user presses enter

mov eax, [0x7e00]
mov ebx, [0x7e04]
mov ecx, [0x7e08]

mov edx, "B3ts"
mov dl, 'L'
cmp eax, edx
jne lose_jmp

rol edx, 8
mov dx, "_G"
cmp ebx, edx
jne lose_jmp

mov dh, 'W'             ; This whole routine checks that the user entered "L3ts_G3t_W3t"
cmp ecx, edx
jne lose_jmp

mov al, [0x7e0c]
xor bl, bl
cmp al, bl
jne lose_jmp

biosprint win
jmp done

lose_jmp:
biosprint lose

done:
jmp $

; Make the bootblock exactly 512 bytes long
times 510 - ($ - $$) db 0
dw 0xAA55
