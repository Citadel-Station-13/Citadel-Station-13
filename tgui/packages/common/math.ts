/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const clamp = (value: number, low: number, high: number) => {
  return value < low ? low : (value > high ? high : value);
};

/**
 * Return closest higher multiple of 'multiple' from value
 * @param {number} value
 * @param {number} multiple
 * @return {number}
 */
export const ceiling = (value: number, multiple: number): number => {
  let mult = value / multiple;
  return Math.ceil(mult) * multiple;
};

/**
 * Return closest lower multiple of 'multiple' from value
 * @param {number} value
 * @param {number} multiple
 * @return {number}
 */
export const floor = (value: number, multiple: number): number => {
  let mult = value / multiple;
  return Math.floor(mult) * multiple;
};

/**
 * Get array of bits from a bitfield
 */
export const bitfieldToBits = (field: number) => {
  let got: number[] = [];
  for (let bit = 0; bit < 24; bit++) {
    if (field & (1 << bit)) {
      got.push(1 << bit);
    }
  }
  return got;
};

/**
 * Get array of positions from a bitfield
 */
export const bitfieldToPositions = (field: number, limit: number = 24) => {
  let got: number[] = [];
  for (let bit = 0; bit < limit; bit++) {
    if (field & (1 << bit)) {
      got.push(bit);
    }
  }
  return got;
};
