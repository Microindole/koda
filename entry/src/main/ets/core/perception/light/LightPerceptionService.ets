import { VibeProvider } from '../VibeProvider';
import { AmbientLightAdapter, AmbientLightData } from './AmbientLightAdapter';

export type LightListener = (lux: number) => void;

export class LightPerceptionService implements VibeProvider<number> {
  private timerId: number = -1;
  private mockLux: number = 150;
  private subscribedWithSensor: boolean = false;
  private sensorCallback?: (data: AmbientLightData) => void;
  private readonly ambientLightAdapter: AmbientLightAdapter = new AmbientLightAdapter();

  start(listener: LightListener): void {
    if (this.timerId !== -1 || this.subscribedWithSensor) {
      return;
    }
    if (this.tryStartSensor(listener)) {
      return;
    }
    this.startMock(listener);
  }

  stop(): void {
    this.stopSensor();
    this.stopMock();
  }

  isRunning(): boolean {
    return this.subscribedWithSensor || this.timerId !== -1;
  }

  private tryStartSensor(listener: LightListener): boolean {
    // TODO: Enforce strict sensor payload type after SDK returns stable ambient-light schema.
    this.sensorCallback = (data: AmbientLightData): void => {
      listener(this.extractLux(data));
    };

    if (this.sensorCallback === undefined) {
      this.sensorCallback = undefined;
      return false;
    }
    this.subscribedWithSensor = this.ambientLightAdapter.start(this.sensorCallback);
    if (!this.subscribedWithSensor) {
      this.sensorCallback = undefined;
    }
    return this.subscribedWithSensor;
  }

  private stopSensor(): void {
    if (!this.subscribedWithSensor || this.sensorCallback === undefined) {
      return;
    }

    this.ambientLightAdapter.stop();
    this.subscribedWithSensor = false;
    this.sensorCallback = undefined;
  }

  private startMock(listener: LightListener): void {
    this.timerId = setInterval(() => {
      this.mockLux = this.nextMockLux(this.mockLux);
      listener(this.mockLux);
    }, 1000) as number;
  }

  private stopMock(): void {
    if (this.timerId === -1) {
      return;
    }
    clearInterval(this.timerId);
    this.timerId = -1;
  }

  private extractLux(data: AmbientLightData): number {
    // FIXME: Confirm the exact ambient-light payload field name on target HarmonyOS SDK/device.
    const candidates: (number | undefined)[] = [
      data.intensity,
      data.lightIntensity,
      data.illuminance,
      data.value
    ];

    for (let i = 0; i < candidates.length; i++) {
      const value = candidates[i];
      if (value !== undefined && isFinite(value) && value >= 0) {
        return value;
      }
    }
    return 0;
  }

  private nextMockLux(prevLux: number): number {
    const delta = Math.random() * 240 - 120;
    const nextLux = prevLux + delta;
    if (nextLux < 0) {
      return 0;
    }
    if (nextLux > 2200) {
      return 2200;
    }
    return nextLux;
  }
}

