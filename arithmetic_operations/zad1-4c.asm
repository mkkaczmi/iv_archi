;=============================================================================;
;                                                                             ;
; Plik           : arch1-4c.asm                                               ;
; Format         : COM                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie programów           ;
;                  asemblerowych                                              ;
; Autorzy        : Jakub Grala, Michał Kaczmarek, grupa 2-1, piątek, 12:15    ;
; Data zaliczenia: 28.03.2025                                                 ;
; Uwagi          : Program obliczajacy srednia arytmetyczna liczb w tablicy   ;
;                                                                             ;
;=============================================================================;

                .MODEL  TINY	                        ; segment danych 64KB, dla plików COM, jeden segment dla kodu, danych i stosu

Kod             SEGMENT			                        ; początek segmentu kodu

                ORG     100h	                        ; określenie adresu poczatkowego programu - od 0 do 256 jest PSP (np. INT 21H)
                ASSUME  CS:Kod, DS:Kod, SS:Kod		    ; ustawienie segmentów kodu, danych i stosu na segment Kod

Start:
                jmp     Poczatek		                ; skok do głównej części programu, dane są w pamięci bo COM jest ładowany w całości do segmentu od 100h

DL_TABLICA      EQU     12								; dl tablicy
Tablica         DB      01h, 02h, 00h, 10h, 12h, 33h	; przypisanie tablicy, każda liczba to bajt
                DB      15h, 09h, 11h, 08h, 0Ah, 00h
Srednia         DB      ?								; rezerwuje jeden bajt pamięci na wynik, wartość nieokreślona

Poczatek:
                mov     bx, OFFSET Tablica			    ; bx otrzymuje adres pierwszego elementu w pamięci (OFFSET)
                mov     cx, DL_TABLICA				    ; cx jako licznik pętli
				xor     ax, ax		                    ; zerowanie ax
              

Petla:
                add     al, [bx]                        ; dodawanie wartości z bx do al, al jako suma wszystkich wartości
                inc     bx                              ; kolejny adres z tablicy
				loop    Petla                           ; dekrementacja cx

				
                mov     dl, DL_TABLICA                  ; przeniesienie do dl dlugosci tablicy
                div     dl	                            ; dzielimy rejestr ax przez dl - wynik w al, reszta w ah
				mov     Srednia, al                     

Koniec:         mov     ax, 4C00h		                ; zakończenie programu, kod funkcji DOS zakonczenia programu, 00h w AL to kod wyjścia programu
                int     21h                             ; wywołanie przerwania 21h (PSP)- przekazanie sterowania do systemu DOS

Kod             ENDS                                    ; zamyka segment kodu

                END     Start                           ; określa punkt wejścia do programu