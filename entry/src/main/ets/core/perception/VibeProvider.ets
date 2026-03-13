export type VibeListener<T> = (value: T) => void;

export interface VibeProvider<T> {
  start(listener: VibeListener<T>): void;
  stop(): void;
  isRunning(): boolean;
}
