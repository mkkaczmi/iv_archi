;---------------------------------------------------------------------------------------------------------;
;	Zadanie			:	2
;	Format			:	.COM
;	Autor			:	Michał Kaczmarek, Jakub Grala
;	Grupa			:	piątek 12:15-13:45
;	Data przesłania	:	25.04.2025r.
;---------------------------------------------------------------------------------------------------------;

				.386				; Obsluga rejestrów 32-bitowych
				.MODEL TINY

SekcjaKodu		SEGMENT USE16		; Użycie segmentów 16-bitowych

				ORG     100h		; OFFSET 100h, przesuń o 256 bajtów od początku segmentu
				ASSUME  CS:SekcjaKodu, DS:SekcjaKodu, SS:SekcjaKodu

Start:
;---------------------------------------------------------------------------------------------------------
Main	PROC							; Deklaracja procedury 'Main'
				call    PobierzLiczbe	; Wywołanie procedury do pobrania liczby
				call    Przekonwertuj

				cwde					; konwersja z 16 na 32 bity
                
				mov     zapisanyWynik, eax ; przypisanie 32 bitowej wartość do rejestru rozszerzonego (32 bitowego)

				call    PobierzLiczbe
				call    Przekonwertuj

				cwde					; Rozszerzenie do 32 bitów

				mov     ebx, zapisanyWynik
				add     eax, ebx
				mov     zapisanyWynik, eax
Wynik:

				mov     dx, offset wiadomoscWynik
				mov     ah, 09h
				int     21h

				call    WyswietlWynik

				call    ZakonczProgram

				komunikatWejscie DB  0Dh, 0Ah, "Wprowadz liczbe z zakresu [-32768,32767]: $" ; 0Dh - początek linii, 0Ah - przejście do nowej linii
				komunikatBlad   DB  0Dh, 0Ah, "BLAD! Wprowadzono nieprawidlowa liczbe!$"
				wiadomoscWynik  DB  0Dh, 0Ah, "Wynik: $"
				rozmiarBufora   DB  8
				iloscZnakow     DB  ?
				tablicaLiczb    DB  8 DUP(?)		; rezerwowanie 8 niezainicjalizowanych bajtów
				flagaUjemnosci  DB  ?
				zapisanyWynik   DD  ?

Main	ENDP
;---------------------------------------------------------------------------------------------------------
PobierzLiczbe	PROC

				mov		dx, offset komunikatWejscie	; ustawienie dx jako początek adresu komunikatu
				mov		ah, 09h						; ah=09h wyświetla łańcuch znaków
				int		21h							; wyświetlenie komunikatu

				mov		dx, offset rozmiarBufora	; ustawienie dx jako początek adresu rozmiaru bufora
				mov		ah, 0Ah						; ah=0Ah, buforowane wejście z DOS
				int		21h							; wykonanie 0Ah, czyli wprowadzenia wartości

				ret									; powrót do miejsca wywołania

PobierzLiczbe 	ENDP
;---------------------------------------------------------------------------------------------------------
Przekonwertuj	PROC

				mov		flagaUjemnosci, 00h			; inicjalizacja flagi ujemności na 0 (brak)
				xor		cx, cx						; zerowanie rejestru cx
				mov		cl, iloscZnakow				; ładowanie ilości znaków do dolnego rejestru (8 pierwszych bitów rejestru cx)
				mov		si, offset tablicaLiczb		; ustawia si na początek tablicy z liczbami
				mov		di, 10						; ustawia di na 10, podstawa systemu dziesiętnego
				mov		bl, byte ptr [si]			; ładuje pierwszy znak z tablicy do bl

				cmp		bl, '-'						
				je		WykrytoMinus

Kontynuuj:
				cmp		cl, 05h						; sprawdzenie czy liczba znaków nie jest większa niż 5
				ja		ObslugaBledu

				xor		ax, ax						; zerowanie rejestru
				xor		bx, bx						; zerowanie rejestru

KonwertujNaInteger:
                mul     di							; mnożenie ax przez 10 (przesunięcie miejsca dziesiętnego w lewo)
                mov     bl, byte ptr[si]			; ładowanie następnego znaku z tablicy do bl
				inc     si							; przesunięcie wskaźnika si na następny znak
                
                cmp     bl, '0'						; sprawdzenie czy znak jest prawidłowy (większy od 0 - nie jest cyfrą)
                jb      ObslugaBledu				
                cmp     bl, '9'						; sprawdzenie czy znak jest prawidłowy (mniejszy od 9 - nie jest cyfrą)
                ja      ObslugaBledu				

                sub     bl, '0'						; konwersja ASCII na wartość liczbową - odejmowanie kodów ASCII
                add     ax, bx						; dodaje cyfrę do wyniku w ax
                loop    KonwertujNaInteger			; zmniejszenie wartości cx

                mov     bl, flagaUjemnosci			; ładowanie wartości flagi do bl
                cmp     bl, '-'						
                je      KonwertujNaUjemna			
                
                cmp     ax, 7FFFh					; sprawdza czy ax nie przekracza wartości 32767
                ja      ObslugaBledu

                ret									; zwrócenie wyniku

WykrytoMinus:
                mov     flagaUjemnosci, bl			; ustawia flagę ujemności na "-"
                inc     si							; przesuwa wskaźnik si na następny znak
                dec     cl							; zmniejsza licznik znaków
                
                jmp     Kontynuuj

KonwertujNaUjemna:
                mov     flagaUjemnosci, 00h			; zerowanie flagi ujemności
                cmp     ax, 8000h					; sprawdzenie czy ax nie przekracza 32768
                ja      ObslugaBledu
                
                neg     ax							; negacja ax (zmiana wartości na ujemną)
                
                ret
                
ObslugaBledu:
                call    WyswietlBlad				; przejście do procedury wyświetlenia błędu
                call    PobierzLiczbe				; ponowne pobranie liczby
                call    Przekonwertuj				; ponowne przekonwertowanie
                
                ret
                
Przekonwertuj   ENDP
;---------------------------------------------------------------------------------------------------------
WyswietlBlad    PROC

                mov     dx, offset komunikatBlad	; wczytanie do dx początku adresu komórki z komunikatem błędu
                mov     ah, 09h         			; ah=09h wyświetla łańcuch znaków
                int     21h							; wyświetlenie komunikatu
                
                ret
                
WyswietlBlad    ENDP
;---------------------------------------------------------------------------------------------------------
WyswietlWynik   PROC

				mov		eax, zapisanyWynik
                mov     ebx, 10
                xor     cx, cx
                
                cmp     eax, 0
                jge     KonwertujNaString
                
                push    eax
                
                mov     dl, '-'
                mov     ah, 02h         ; ah=02h wysyła na konsolę znak z rejestru dx
                int     21h
                
                pop     eax
                neg     eax
                
KonwertujNaString:
                xor     dx, dx
                div     ebx
                
                add     dl, '0'
                push    dx
                inc     cx
                cmp     ax, 0h
                je      DrukujLiczbe
                jmp     KonwertujNaString
                
DrukujLiczbe:
                pop     dx
                mov     ah, 02h
                int     21h
                loop    DrukujLiczbe
                
                ret
                
WyswietlWynik   ENDP
;---------------------------------------------------------------------------------------------------------
ZakonczProgram  PROC

                mov     ax, 4C00h
                int     21h

ZakonczProgram  ENDP
;---------------------------------------------------------------------------------------------------------
SekcjaKodu      ENDS

                END     Start