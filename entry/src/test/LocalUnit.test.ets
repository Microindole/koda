import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { normalizeLux } from '../main/ets/core/perception/light/LightLevelNormalizer';
import { classifyModeByLight, KodaMode } from '../main/ets/core/state/LightModeClassifier';
import { KodaState } from '../main/ets/core/state/KodaState';

export default function localUnitTest() {
  describe('localUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    });

    it('normalizeLux_shouldClampToZero', 0, () => {
      expect(normalizeLux(-20)).assertEqual(0);
    });

    it('normalizeLux_shouldClampToOne', 0, () => {
      expect(normalizeLux(9999)).assertEqual(1);
    });

    it('classifyModeByLight_shouldMapRanges', 0, () => {
      expect(classifyModeByLight(0.2)).assertEqual(KodaMode.Stealth);
      expect(classifyModeByLight(0.5)).assertEqual(KodaMode.PowerSave);
      expect(classifyModeByLight(0.9)).assertEqual(KodaMode.Vivid);
    });

    it('kodaState_subscribe_shouldReceiveInitialSnapshot', 0, () => {
      const state = new KodaState();
      let latestLux = -1;
      let latestMode = KodaMode.Vivid;

      const unsubscribe = state.subscribe((snapshot) => {
        latestLux = snapshot.lux;
        latestMode = snapshot.mode;
      });

      expect(latestLux).assertEqual(0);
      expect(latestMode).assertEqual(KodaMode.Stealth);
      unsubscribe();
    });

    it('kodaState_updateFromLux_shouldNotifySubscribers', 0, () => {
      const state = new KodaState();
      let notifyCount = 0;
      let latestNormalized = -1;

      const unsubscribe = state.subscribe((snapshot) => {
        notifyCount += 1;
        latestNormalized = snapshot.normalizedLight;
      });

      state.updateFromLux(1000);

      expect(notifyCount).assertEqual(2);
      expect(latestNormalized).assertEqual(0.5);
      expect(state.getSnapshot().mode).assertEqual(KodaMode.PowerSave);
      unsubscribe();
    });

    it('kodaState_unsubscribe_shouldStopNotifications', 0, () => {
      const state = new KodaState();
      let notifyCount = 0;
      const unsubscribe = state.subscribe(() => {
        notifyCount += 1;
      });

      unsubscribe();
      state.updateFromLux(1800);

      expect(notifyCount).assertEqual(1);
    });
  });
}
