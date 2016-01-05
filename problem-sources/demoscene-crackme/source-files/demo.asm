[BITS 16]
[ORG 0x7c00]

; Set display mode
mov ax,0x13
int 0x10

push 0xa000
pop ds

main:
  cmp ax, 0
  jne not_wrapped
    mov ax, 319
  not_wrapped:
  pusha
  call make_stripes
  popa
  dec ax
jmp main

make_stripes:
  push 0xA000
  pop ds
  xor bx, bx ; memory pointer
  render:
    cmp ax, 0x0000 ; Is it time to draw the arrow piece yet?
    jne noarrow
      mov dword [bx], 0x07070707 ; Draw the arrow piece (4 white pixels)
      add bx, 4
      cmp bx, 0x7c00 ; Are we halfway through the screen?
      jb top_half
        pusha
        call write_phrase
        popa
        push 0xA000
        pop ds
        add ax, 157
        jmp noarrow
      top_half:
        add ax, 155
        jmp noarrow
    noarrow:

    mov byte [bx], 0x03
    dec ax
    inc bx
    cmp bx, 0xfa00
  jb render
  ret

write_phrase:
  mov dx, 0x7100
  mov cx, str
  write:
    add dx, 6
    push 0x0000
    pop ds
    mov bx, cx
    mov bx, [bx]
    pusha
    call write_letter
    popa
    push 0x0000
    pop ds
    add cx, 2
    mov bx, cx
    mov bx, [bx]
    cmp word bx, 0
  jne write
  ret

; dx = set to the position to write at
; bx = the letter
write_letter:
  mov al, 0
  mov ah, 0
  write_letter_rows:
    write_letter_row:

      ; I hate segmentation
      push 0x0000
      pop ds
      mov cl, [bx]
      inc bx
      xchg bx, dx

      ; Like, so much.
      push 0xA000
      pop ds
      mov [bx], cl ; Transfer character byte to VGA memory
      inc bx
      xchg bx, dx
      inc al
      cmp al, 5
    jb write_letter_row

    xchg bx, dx
    mov byte [bx], 0
    xchg bx, dx

    mov al, 0
    add dx, 315
    inc ah
    cmp ah, 5
  jb write_letter_rows

  ret

n db 9, 0, 0, 0, 9, \
     9, 9, 0, 0, 9, \
     9, 0, 9, 0, 9, \
     9, 0, 0, 9, 9, \
     9, 0, 0, 0, 9

r db 9, 0, 9, 9, 0, \
     9, 9, 0, 0, 9, \
     9, 0, 0, 0, 0, \
     9, 0, 0, 0, 0, \
     9, 0, 0, 0, 0

u db 9, 0, 0, 0, 9, \
     9, 0, 0, 0, 9, \
     9, 0, 0, 0, 9, \
     9, 0, 0, 0, 9, \
     9, 9, 9, 9, 9

y db 9, 0, 0, 0, 9, \
     0, 9, 0, 9, 0, \
     0, 0, 9, 0, 0, \
     0, 0, 9, 0, 0, \
     0, 0, 9, 0, 0

s db 0, 9, 9, 9, 9, \
     9, 0, 0, 0, 0, \
     0, 9, 9, 9, 0, \
     0, 0, 0, 0, 9, \
     9, 9, 9, 9, 0

o db 0, 9, 9, 9, 0, \
     9, 0, 0, 0, 9, \
     9, 0, 0, 0, 9, \
     9, 0, 0, 0, 9, \
     0, 9, 9, 9, 0

m db 9, 0, 0, 0, 9, \
     9, 9, 0, 9, 9, \
     9, 0, 9, 0, 9, \
     9, 0, 0, 0, 9, \
     9, 0, 0, 0, 9

t db 9, 9, 9, 9, 9, \
     0, 0, 9, 0, 0, \
     0, 0, 9, 0, 0, \
     0, 0, 9, 0, 0, \
     0, 0, 9, 0, 0

i db 9, 9, 9, 9, 9, \
     0, 0, 9, 0, 0, \
     0, 0, 9, 0, 0, \
     0, 0, 9, 0, 0, \
     9, 9, 9, 9, 9

skid db 0, 0, 0, 0, 0, \
        0, 0, 0, 0, 0, \
        0, 0, 0, 0, 0, \
        0, 0, 0, 0, 0, \
        9, 9, 9, 9, 9

; Key = sometimes_you_must_run_it
str: dw y,o,u,             skid, \
        m,u,s,t,           skid, \
        r,u,n,             skid, \
        i,t, 0

; Busy wait, waits about a second on my Atom notebook
sleep:
  mov eax, dword 0x0000ffff
  top:
    test eax, eax
    je sleep_end
    dec eax
    jmp top
  sleep_end:
    ret

; Make the bootblock exactly 512 bytes long
times 510 - ($ - $$) db 0
dw 0xAA55
