export function clamp(value: number, minValue: number, maxValue: number): number {
  if (value < minValue) {
    return minValue;
  }
  if (value > maxValue) {
    return maxValue;
  }
  return value;
}

export function normalizeLux(lux: number, minLux: number = 0, maxLux: number = 2000): number {
  if (maxLux <= minLux) {
    return 0;
  }
  const clampedLux = clamp(lux, minLux, maxLux);
  return (clampedLux - minLux) / (maxLux - minLux);
}
