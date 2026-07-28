/**
 * decodes RGB(A) string; output values are 0 to 255
 * alpha defualts to max if it isn't in the string
 *
 * @param str - rgb string, as #abc or #aabbcc or abc or aabbcc
 */
export const DecodeRGBString = (str: string): [number, number, number, number] => {
  let strLen = str.length;
  // get rid of everything and ensure RRGGBBAA format.
  switch (strLen) {
    case 3:
      str = `${str[0]}${str[0]}${str[1]}${str[1]}${str[2]}${str[2]}ff`;
      break;
    case 4:
      if (str[0] !== "#") {
        throw new Error("unexepected string without #");
      }
      str = `${str[1]}${str[1]}${str[2]}${str[2]}${str[3]}${str[3]}ff`;
      break;
    case 7:
      if (str[0] !== "#") {
        throw new Error("unexepected string without #");
      }
      str = str.substring(1);
      break;
    case 9:
      if (str[0] !== "#") {
        throw new Error("unexepected string without #");
      }
      str = str.substring(1);
      break;
    default:
      throw new Error("unexpected string length");
  }
  // convert to upper
  str = str.toUpperCase();
  // sanitize string
  for (let i = 0; i < 8; ++i) {
    let char = str.charCodeAt(i);
    if ((char < 48 || char > 57) && (char < 65 || char > 70)) {
      throw new Error(`unexpected char ${str.charAt(i)} at position ${i}}`);
    }
  }
  // get values
  let rCode1 = str.charCodeAt(0);
  let rCode2 = str.charCodeAt(1);
  let gCode1 = str.charCodeAt(2);
  let gCode2 = str.charCodeAt(3);
  let bCode1 = str.charCodeAt(4);
  let bCode2 = str.charCodeAt(5);
  let aCode1 = str.charCodeAt(6);
  let aCode2 = str.charCodeAt(7);
  return [
    (rCode1 > 57? rCode1 - (7 + 48) : rCode1 - (48)) * 16 + (rCode2 > 57? rCode2 - (7 + 48) : rCode2 - (48)),
    (gCode1 > 57? gCode1 - (7 + 48) : gCode1 - (48)) * 16 + (gCode2 > 57? gCode2 - (7 + 48) : gCode2 - (48)),
    (bCode1 > 57? bCode1 - (7 + 48) : bCode1 - (48)) * 16 + (bCode2 > 57? bCode2 - (7 + 48) : bCode2 - (48)),
    (aCode1 > 57? aCode1 - (7 + 48) : aCode1 - (48)) * 16 + (aCode2 > 57? aCode2 - (7 + 48) : aCode2 - (48)),
  ];
};

/**
 * inputs are 0 to 255.
 *
 * @param r
 * @param g
 * @param b
 * @param includeHash
 */
export const EncodeRGBString = (r: number, g: number, b: number, includeHash: boolean): string => {
  return `${includeHash && "#"}${Math.round(r).toString(16).padStart(2, "0")}${Math.round(g).toString(16).padStart(2, "0")}${Math.round(b).toString(16).padStart(2, "0")}`;
};

/**
 * inputs are 0 to 255.
 *
 * @param r
 * @param g
 * @param b
 * @param a
 * @param includeHash
 */
export const EncodeRGBAString = (r: number, g: number, b: number, a: number | null, includeHash: boolean): string => {
  return `${includeHash && "#"}${Math.round(r).toString(16).padStart(2, "0")}${Math.round(g).toString(16).padStart(2, "0")}${Math.round(b).toString(16).padStart(2, "0")}${Math.round(a || 255).toString(16).padStart(2, "0")}`;
};

/**
 * HSV to RGB
 *
 * input are H: 0 to 360, S: 0 to 100, V: 0 to 100
 * output are 0 to 255
 */
export const HSVtoRGB = (h: number, s: number, v: number): [number, number, number] => {
  s = s / 100;
  v = v / 100;
  let c = v * s;
  let x = c * (1 - Math.abs(((h / 60) % 2) - 1));
  let m = v - c;
  let r = 0;
  let g = 0;
  let b = 0;
  if (h < 60) {
    r = c;
    g = x;
  }
  else if (h <= 120) {
    r = x;
    g = c;
  }
  else if (h <= 180) {
    g = c;
    b = x;
  }
  else if (h <= 240) {
    g = x;
    b = c;
  }
  else if (h <= 300) {
    r = x;
    b = c;
  }
  else if (h <= 360) {
    r = c;
    b = x;
  }
  return [(r + m) * 255, (g + m) * 255, (b + m) * 255];
};

/**
 * RGB to HSV
 *
 * input are 0 to 255
 * output are H: 0 to 360, S: 0 to 100, V: 0 to 100
 */
export const RGBtoHSV = (r: number, g: number, b: number): [number, number, number] => {
  r = r / 255;
  g = g / 255;
  b = b / 255;
  let cMax = Math.max(r, g, b);
  let cMin = Math.min(r, g, b);
  let delta = cMax - cMin;
  let h;
  if (delta === 0) {
    h = 0;
  }
  else if (cMax === r) {
    h = (60 * ((g - b) / delta) + 360) % 360;
  }
  else if (cMax === g) {
    h = (60 * ((b - r) / delta) + 120) % 360;
  }
  else if (cMax === b) {
    h = (60 * ((r - g) / delta) + 240) % 360;
  }
  else {
    throw new Error("Neither R nor G nor B matched cMax and Delta is nonzero.");
  }
  let s = cMax === 0? 0 : delta / cMax;
  return [h, s * 100, cMax * 100];
};
