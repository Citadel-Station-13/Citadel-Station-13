/**
 * Converts a browser keycode to BYOND keycode. This is lifted from tgstation's.
 *
 * TODO: how's tgstation doing this surely they aren't doing the same.
 */
export function keyCodeToByond(keyCode: number) {
  if (keyCode === 16) return 'Shift';
  if (keyCode === 17) return 'Ctrl';
  if (keyCode === 18) return 'Alt';
  if (keyCode === 33) return 'Northeast';
  if (keyCode === 34) return 'Southeast';
  if (keyCode === 35) return 'Southwest';
  if (keyCode === 36) return 'Northwest';
  if (keyCode === 37) return 'West';
  if (keyCode === 38) return 'North';
  if (keyCode === 39) return 'East';
  if (keyCode === 40) return 'South';
  if (keyCode === 45) return 'Insert';
  if (keyCode === 46) return 'Delete';

  if ((keyCode >= 48 && keyCode <= 57) || (keyCode >= 65 && keyCode <= 90)) {
    return String.fromCharCode(keyCode);
  }
  if (keyCode >= 96 && keyCode <= 105) {
    return `Numpad${keyCode - 96}`;
  }
  if (keyCode >= 112 && keyCode <= 123) {
    return `F${keyCode - 111}`;
  }
  if (keyCode === 188) return ',';
  if (keyCode === 189) return '-';
  if (keyCode === 190) return '.';
  return null;
}
