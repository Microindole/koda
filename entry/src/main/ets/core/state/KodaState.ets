import { normalizeLux } from '../perception/light/LightLevelNormalizer';
import { classifyModeByLight, KodaMode } from './LightModeClassifier';

export interface KodaSnapshot {
  lux: number;
  normalizedLight: number;
  mode: KodaMode;
}

type KodaListener = (snapshot: KodaSnapshot) => void;

export class KodaState {
  private snapshot: KodaSnapshot = {
    lux: 0,
    normalizedLight: 0,
    mode: KodaMode.Stealth
  };

  private listeners: KodaListener[] = [];

  updateFromLux(lux: number): void {
    const normalizedLight = normalizeLux(lux);
    const mode = classifyModeByLight(normalizedLight);
    this.snapshot = {
      lux: lux,
      normalizedLight: normalizedLight,
      mode: mode
    };
    this.notify();
  }

  getSnapshot(): KodaSnapshot {
    return this.snapshot;
  }

  subscribe(listener: KodaListener): () => void {
    this.listeners.push(listener);
    listener(this.snapshot);
    return (): void => {
      this.listeners = this.listeners.filter((item: KodaListener) => item !== listener);
    };
  }

  private notify(): void {
    this.listeners.forEach((listener: KodaListener) => listener(this.snapshot));
  }
}
