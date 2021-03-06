; Zero Divide
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
        cmp ax,08800h                   ;*FILE SIZE TO PUT!*
        jnz file_size_is_incorrect
        cmp dx,000eh                    ;*FILE SIZE TO PUT!*
        jnz file_size_is_incorrect

first_modif:
        xor cx,cx                       ;*FILE OFFSET TO PUT!*
        mov dx,09257h                   ;*FILE OFFSET TO PUT!*
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
DB'     �                                       �                       �   �      '
DB'     �  �               �          ���  � ��  ����                  ���� ��     '
DB'   � ���  ��� ����   ���  ��   � ����   � ���   ���� �  � ����� � ��� �� �� ��  '
DB'   � �����  ���� ������  �� ���������� ���������� ����۲��  �������۲��  ��� �  '
DB'   � �������  � ���� ���  ���� ��  ��  ��        ���� ���  ���� �  ��� � ��� �  '
DB'     ��� ����� ��� � ��� ���  ��� �� ���� ��� � ��� � ��� ���  ��� ��� � ��� ۰ '
DB'   � ��� � ���� �� � ��� ���� ���  ����  ���� � ���   ��� �������  ��� � ��� ۱ '
DB'   � ��� � ���� �� ����� �� �ݲ������ ܲ ���� � ��� ����� �    ���� �� ����� �� '
DB'  �� ��� ����� ���   ��� �� � ��� ���� � ���� � ��� � ��� �����  ��� � � ��� �  '
DB'  �� ��� � ���� �� � ��� ���  ��� � ���� ���� � ��� � ���   ߲�� ��� � � ��� �  '
DB'  ��     ��  ��� � � ��� ����     ��  ��� ����        ���  �   ����� � � ���    '
DB'   ������������� � � ���  �������۲�� ���  ���۲�� �� ��� �������� ����� ��� �  '
DB'            �    �   ��� ��   ���  �  ��� ��� �       �            �   ����� �  '
DB'     � �� ������� �� ��  ���   �� ���� � ��������� �  � � ASCII<ROY/SAC>  �  �  '
DB'      � ���� �  �      �  �  � �   �� � proudly presents                  �     '
DB' �����                                                                    ���Ŀ '
DB' �� �          Cyrix-Fix for ZERO DIVIDE -=- by lgb [10/13/97]             � �� '
DB' ��������                                                              �������� '
BLH_LOGO_E:


opening_file_error:
        db ' � Can''t open file to be patched.$'

unknown_err:
        db ' � Unknown error while trying patching file.$'

size_incorrect:
        db ' � The file to be patched size is wrong. Perhaps is is not the right version.$'

patch_ok:
        db ' � Fixed okay. Will now run on Cyrix 6x86 CPUs.$'

file_to_be_patched:
        db 'ZD.EXE',00h
handle:
        end     main
