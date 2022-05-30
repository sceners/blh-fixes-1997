; Toshinden 2
; Cyrix Fix
;
; coded by lgb
; [france, 1997]
; *386 Code* used.
; feel free to use/hack/modify/rip/..

.model tiny
.code
.386
org 100h
main:

        nop
        mov ax,0003h             ;Clear da screen, and put resolution
        int 10h                  ;80x25 16 colors

        push cs
        push 0b800h
        pop es
        pop ds

        mov si,offset(BLH_LOGO_B) ;SI=offset BLH_LOGO
        xor di,di                ;DI=0
        mov cx,offset(BLH_LOGO_E)-offset(BLH_LOGO_B)
        cld                      ;clear direction flag

copy_all_screen:
        movsb
        inc di
        loop copy_all_screen

        mov dx,1300h
        mov ah,02h
        xor bx,bx
        int 10h

        mov ax,3d02h
        mov dx,offset(file_to_be_patched)
        int 21h
        jc error_opening_file
        mov word ptr [handle],ax

check_file_size:
        mov ax,4202h
        xor cx,cx
        xor dx,dx
        mov bx,word ptr [handle]
        int 21h
        jc unknown_error
        cmp ax,01e00h                   ;*FILE SIZE TO PUT!*
        jnz file_size_is_incorrect
        cmp dx,000fh                    ;*FILE SIZE TO PUT!*
        jnz file_size_is_incorrect

first_modif:
        xor cx,cx                       ;*FILE OFFSET TO PUT!*
        mov dx,095e7h                   ;*FILE OFFSET TO PUT!*
        mov ax,4200h
        mov bx,word ptr [handle]
        int 21h
        jc unknown_error
 
        mov ah,40h
        mov bx,word ptr [handle]
        mov cx,1
        mov dx,offset(cracked_pattern1_begin)
        int 21h
        jc unknown_error


        mov dx,offset(patch_ok)
        push cs
        pop ds
        mov ah,09h
        int 21h
        mov ax,4c00h
        int 21h
 
error_opening_file:
        mov dx,offset(opening_file_error)
        jmp print_error_and_exit

unknown_error:
        mov dx,offset(unknown_err)
        jmp print_error_and_exit

file_size_is_incorrect:
        mov dx,offset(size_incorrect)

print_error_and_exit:
        push cs
        pop ds
        mov ah,09h
        int 21h
        mov ax,4cffh
        int 21h

cracked_pattern1_begin:
        DB 0EBh

BLH_LOGO_B:
DB'     п                                       п                       п   н      '
DB'     л  м               м          млм  н лм  пмлм                  млмп лн     '
DB'   А ллм  пмм млмп   млл  мп   п пппп   л ппп   пппп п  п пмлпп п ппп пп лл пм  '
DB'   Б лпллм  пллп ммллпп  лп ммлллллллп олнллллллп ммлллВБА  ммллллллВБА  ллл л  '
DB'   А ллллллм  п лллп ААА  мллп мм  мм  лл        лллп ммм  лллп м  ммм о ллл л  '
DB'     ллл плллм плл м БББ олл  ллл лп мллп ААА п ллл м ллл ллл  ппм ллл В ллл лА '
DB'   А ллл м пллл лл п ВВВ ллно ллл  мллп  ББББ о ллл   ллл плллммм  ллл п ллл лБ '
DB'   Б ВВВ п мллл лл ллллл лл ВнВВВлллп мВ ВВВВ л ВВВ ллллл м    пллм пл ллллл ВА '
DB'  АВ БББ плллп млл   ллл лл о БББ пллм п лллл В БББ м ллл Алллм  ллл л м ллл Б  '
DB'  Бл ААА м пллм пл н ллл ллн  ААА м пллм пллл н ААА В ллл   пВпп ллл л В ллл А  '
DB'  Ал     пп  ллл л л ллл оллм     пп  ллл лллм        ллл  п   млллп л м ллл    '
DB'   плллллллллллп л м ллл  плллллллВБА ллл  плллВБА АБ ллп Вллллллп млпом ллл А  '
DB'            м    н   ллл пм   ммм  м  плл лмм м       л            о   пнолн Б  '
DB'     п пп пппллмм мн лп  плп   лн пллм л мплмлпппп п  н п ASCII<ROY/SAC>  л  А  '
DB'      п пплп н  п      о  п  п н   лп п proudly presents                  н     '
DB' кФФљњ                                                                    њљФФП '
DB' ГГ ў          Cyrix-Fix for TOSHINDEN 2 -=- by lgb [10/13/97]             ў ГГ '
DB' РФФФФФљњ                                                              њљФФФФФй '
BLH_LOGO_E:


opening_file_error:
        db ' ў Can''t open file to be patched.$'

unknown_err:
        db ' ў Unknown error while trying patching file.$'

size_incorrect:
        db ' ў The file to be patched size is wrong. Perhaps is is not the right version.$'

patch_ok:
        db ' ў Fixed okay. Will now run on Cyrix 6x86 CPUs.$'

file_to_be_patched:
        db 'T2.EXE',00h
handle:
        end     main
