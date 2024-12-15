# tris8086

**tris8086** è una versione del gioco tris (anche chiamato tic-tac-toe) sviluppato interamente in assembly 8086. Supporta sia una modalità **Giocatore vs. Giocatore** sia una modalità **Giocatore vs. CPU**, implementando grafica e input tramite il mouse. Il gioco include logica per il bot e utilizza interrupt dell'ambiente DOS.

## Indice

1. [Requisiti](#requisiti)
2. [Esecuzione](#esecuzione)
3. [Licenza](#licenza)

## Requisiti

Per eseguire il progetto, assicurati di avere un ambiente DOS compatibile, come:

- **DOSBox**: Emulatore DOS multipiattaforma. [Guida all'installazione di DOSBox](https://www.dosbox.com/download.php)
- **Assembler 8086**: Un assembler come MASM o TASM per compilare il codice sorgente, o un emulatore come emu8086.

## Esecuzione

1. Compila il codice sorgente:
    ```bash
    masm tris8086.asm
    link tris8086.obj
    ```

2. Esegui il gioco in un ambiente DOS:
    ```bash
    tris8086.exe
    ```

3. Segui il menu per scegliere una modalità:
    - **Giocatore vs. Giocatore**: Due utenti si alternano al gioco.
    - **Giocatore vs. CPU**: Sfida la CPU euristica implementata in assembly.
    - **Esci**: Termina il programma.

## Licenza

Questo progetto è distribuito sotto licenza MIT. Consulta il file [LICENSE](LICENSE) per ulteriori dettagli.
