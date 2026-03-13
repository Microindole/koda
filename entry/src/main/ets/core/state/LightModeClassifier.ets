export enum KodaMode {
  Stealth = 'Stealth',
  Vivid = 'Vivid',
  PowerSave = 'PowerSave'
}

export function classifyModeByLight(normalizedLight: number): KodaMode {
  if (normalizedLight < 0.3) {
    return KodaMode.Stealth;
  }
  if (normalizedLight > 0.75) {
    return KodaMode.Vivid;
  }
  return KodaMode.PowerSave;
}
