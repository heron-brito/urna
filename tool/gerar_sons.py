"""Gera os efeitos sonoros estilo Duolingo (WAV 16-bit mono 44.1kHz)."""
import math
import struct
import wave
import os

SR = 44100
OUT = '/home/user/urna/assets/sounds/sdm'


def render(events, total, volume=0.8):
    """events: list of (start_s, freq, dur_s, amp, kind)."""
    n = int(total * SR)
    buf = [0.0] * n
    for start, freq, dur, amp, kind in events:
        i0 = int(start * SR)
        nd = int(dur * SR)
        for j in range(nd):
            if i0 + j >= n:
                break
            t = j / SR
            env = math.exp(-t * (5.0 / dur))  # decaimento exponencial
            # ataque rapido para evitar clique
            atk = min(1.0, j / (0.004 * SR))
            if kind == 'sine':
                s = math.sin(2 * math.pi * freq * t)
                s += 0.35 * math.sin(2 * math.pi * freq * 2 * t)
                s += 0.12 * math.sin(2 * math.pi * freq * 3 * t)
            elif kind == 'buzz':  # quadrada suavizada, som de erro
                s = 0.0
                for k in (1, 3, 5):
                    s += math.sin(2 * math.pi * freq * k * t) / k
            elif kind == 'sweep_down':
                f = freq * (1 - 0.5 * (t / dur))
                s = math.sin(2 * math.pi * f * t)
            elif kind == 'sweep_up':
                f = freq * (1 + 0.8 * (t / dur))
                s = math.sin(2 * math.pi * f * t)
            else:
                s = 0.0
            buf[i0 + j] += amp * env * atk * s
    # normaliza
    peak = max(abs(x) for x in buf) or 1.0
    scale = volume / peak
    return [x * scale for x in buf]


def save(name, samples):
    path = os.path.join(OUT, name)
    with wave.open(path, 'w') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        frames = b''.join(
            struct.pack('<h', max(-32767, min(32767, int(s * 32767))))
            for s in samples)
        w.writeframes(frames)
    print('ok', path, len(samples) / SR, 's')


os.makedirs(OUT, exist_ok=True)

# clique curto de botao
save('botao.wav', render([(0, 1800, 0.06, 1.0, 'sine')], 0.09, 0.5))

# "ding-ding" alegre de acerto (E5 -> A5), a cara do Duolingo
save('acerto.wav', render([
    (0.00, 659.25, 0.16, 0.9, 'sine'),
    (0.12, 880.00, 0.30, 1.0, 'sine'),
], 0.5, 0.75))

# "thud" grave duplo de erro
save('erro.wav', render([
    (0.00, 196.0, 0.18, 1.0, 'buzz'),
    (0.16, 155.6, 0.30, 1.0, 'buzz'),
], 0.55, 0.7))

# blip ascendente de ajuda
save('ajuda.wav', render([
    (0.00, 523.25, 0.10, 0.8, 'sine'),
    (0.08, 783.99, 0.16, 1.0, 'sine'),
], 0.3, 0.65))

# whoosh descendente de pular
save('pular.wav', render([(0, 900, 0.28, 1.0, 'sweep_down')], 0.32, 0.55))

# moedas ao parar
save('parar.wav', render([
    (0.00, 1567.98, 0.10, 0.8, 'sine'),
    (0.09, 2093.00, 0.12, 0.9, 'sine'),
    (0.20, 1567.98, 0.10, 0.7, 'sine'),
    (0.29, 2093.00, 0.18, 1.0, 'sine'),
], 0.55, 0.6))

# fanfarra do milhao (arpejo C5 E5 G5 C6 + acorde final)
save('vitoria.wav', render([
    (0.00, 523.25, 0.18, 0.8, 'sine'),
    (0.15, 659.25, 0.18, 0.8, 'sine'),
    (0.30, 783.99, 0.18, 0.8, 'sine'),
    (0.45, 1046.50, 0.50, 1.0, 'sine'),
    (0.62, 523.25, 0.70, 0.5, 'sine'),
    (0.62, 659.25, 0.70, 0.5, 'sine'),
    (0.62, 783.99, 0.70, 0.5, 'sine'),
    (0.62, 1046.50, 0.70, 0.7, 'sine'),
], 1.5, 0.8))
