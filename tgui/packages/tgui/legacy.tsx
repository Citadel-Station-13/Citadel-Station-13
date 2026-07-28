/**
 * @file
 * @license MIT
 */

import { useEffect, useRef, useState } from "react";

/**
 * THIS IS NOT ALLOWED TO BE USED FOR NEW CODE.
 * Old code is often shitcode and don't allow react to check updates properly.
 * This forces.
 */
export const useLegacyForceRendering = () => {
  const [nonsense, setNonsense] = useState(0);
  const timeoutRef = useRef<any>(undefined);
  useEffect(() => {
    timeoutRef.current = setTimeout(() => setNonsense(Math.random()), 20);
    return () => clearTimeout(timeoutRef.current);
  });
};
