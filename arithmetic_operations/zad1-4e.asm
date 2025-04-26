;=============================================================================;
;                                                                             ;
; Plik           : arch1-4e.asm                                               ;
; Format         : EXE                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie programów           ;
;                  asemblerowych                                              ;
; Autorzy        : Jakub Grala, Michał Kaczmarek, grupa 2-1, piątek, 12:15    ;
; Data zaliczenia: 28.03.2025                                                 ;
; Uwagi          : Program obliczajacy wzor: a*(b-c)/d                        ;
;                                                                             ;
;=============================================================================;

                .MODEL  SMALL                               ;Dyrektywa ustawia model pamięci jako SMALL, segmenty danych i kodu są osobne, ale każdy mieści się w 64KB.

Dane            SEGMENT

a               DW      20                                  ;define word, zapisanie 16 bitowej zmiennej
b               DW      10
c               DW      5
d               DW      3
Wynik           DW      ?                                   

Dane            ENDS                                      	

Kod             SEGMENT                                   	

                ASSUME  CS:Kod, DS:Dane, SS:Stosik          ;Mówi asemblerowi jak traktować segmenty w kodzie, nie zmienia wartości rejestrów

Start:
				mov     ax, SEG Dane
                mov     ds, ax
				
				mov		ax, b				
				sub     ax, c
				mul		a
				div     d
				mov     Wynik, ax						
                

                mov     ax, 4C00h                           ;rejestr ogólnego przeznaczenia ax ustawiany na zakończenie programu + kod wyjścia 0
                int     21h                                 ;przerwanie dos-a, wywołuje funkcję 4Ch DOS-a (zakończenie programu (AH), kod wyjścia w AL)

Kod             ENDS                                       

Stosik          SEGMENT STACK                               ;Linker ustawia automatycznie segment stosu i przypisze go do SS 
                DB      100h DUP (?)                        ;Linker ustawi SP na koniec segmentu 0100h czylu 256 bajtów stosu
Stosik          ENDS                                       

                END     Start                               ;Dyrektywa END Start informuje asembler i linker, że to koniec kodu źródłowego, i że program ma się rozpocząć od etykiety Start