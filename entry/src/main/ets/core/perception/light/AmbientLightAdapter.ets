import sensor from '@ohos.sensor';

export interface AmbientLightData {
  intensity?: number;
  lightIntensity?: number;
  illuminance?: number;
  value?: number;
}

interface SensorTypeMap {
  SENSOR_TYPE_ID_AMBIENT_LIGHT?: number;
}

interface SensorApi {
  SensorType?: SensorTypeMap;
  on: (sensorTypeId: number, callback: (data: AmbientLightData) => void, options?: object) => void;
  off: (sensorTypeId: number, callback: (data: AmbientLightData) => void) => void;
}

export class AmbientLightAdapter {
  private readonly sensorApi: SensorApi = sensor as SensorApi;
  private ambientLightType?: number;
  private callback?: (data: AmbientLightData) => void;

  start(callback: (data: AmbientLightData) => void): boolean {
    this.callback = callback;
    try {
      this.ambientLightType = this.sensorApi.SensorType?.SENSOR_TYPE_ID_AMBIENT_LIGHT;
      if (this.ambientLightType === undefined) {
        this.callback = undefined;
        return false;
      }
      this.sensorApi.on(this.ambientLightType, callback, { interval: 200000000 });
      return true;
    } catch (_error) {
      this.callback = undefined;
      this.ambientLightType = undefined;
      return false;
    }
  }

  stop(): void {
    if (this.callback === undefined || this.ambientLightType === undefined) {
      return;
    }
    try {
      this.sensorApi.off(this.ambientLightType, this.callback);
    } catch (_error) {
      // FIXME: Verify whether specific sensor off errors should be surfaced to telemetry.
    } finally {
      this.callback = undefined;
      this.ambientLightType = undefined;
    }
  }
}
