import { LightPerceptionService } from '../core/perception/light/LightPerceptionService';
import { VibeProvider } from '../core/perception/VibeProvider';
import { KodaSnapshot, KodaState } from '../core/state/KodaState';
import { KodaMode } from '../core/state/LightModeClassifier';

@Entry
@Component
struct Index {
  @State lux: number = 0;
  @State normalizedLight: number = 0;
  @State mode: KodaMode = KodaMode.Stealth;

  private perception: VibeProvider<number> = new LightPerceptionService();
  private kodaState: KodaState = new KodaState();
  private unsubscribe?: () => void;

  aboutToAppear(): void {
    this.unsubscribe = this.kodaState.subscribe((snapshot: KodaSnapshot) => {
      this.lux = snapshot.lux;
      this.normalizedLight = snapshot.normalizedLight;
      this.mode = snapshot.mode;
    });
    this.perception.start((lux: number) => this.kodaState.updateFromLux(lux));
  }

  aboutToDisappear(): void {
    this.perception.stop();
    if (this.unsubscribe) {
      this.unsubscribe();
      this.unsubscribe = undefined;
    }
  }

  private modeColor(): string {
    if (this.mode === KodaMode.Vivid) {
      return '#FB7299';
    }
    if (this.mode === KodaMode.PowerSave) {
      return '#6B7A8F';
    }
    return '#00FF66';
  }

  build() {
    Column({ space: 12 }) {
      Text('koda sensor panel')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#E6EDF3')
      Text(`Lux: ${this.lux.toFixed(1)}`)
        .fontSize(22)
        .fontColor('#E6EDF3')
      Text(`Normalized: ${this.normalizedLight.toFixed(3)}`)
        .fontSize(18)
        .fontColor('#B8C3CF')
      Text(`Mode: ${this.mode}`)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.modeColor())
      Text('Ambient light sensor active; fallback to mock if unavailable')
        .fontSize(14)
        .fontColor('#9AA7B5')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .linearGradient({
      angle: 180,
      colors: [['#101820', 0.0], ['#1D2A38', 1.0]]
    })
  }
}

