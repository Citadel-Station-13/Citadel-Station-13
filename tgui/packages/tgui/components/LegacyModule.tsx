
/**
 * /datum/tgui_module stuff
 * Citadel in house
 * Suffer.
 *
 * Basically, how this works, is we inject the module's
 * id, ref, data, and act into context, fetched with useModule().
 *
 * id: The tgui's module id from props; obviously must be unique
 * module: The tgui module's interface name
 * ref: The tgui_module's datum ref
 * data: The module's data passed into data.modules
 * act: A pre-built act function that automatically routes to the right datum procs.
 *
 * You should use the provided act instead of the one from useBackend().
 * useBackend() still works fine to grab the overall non-module context.
 *
 * @file
 * @license MIT
 */

import React, { Component, createContext } from "react";

import { useBackend } from "../backend";
import { getComponentForRoute } from "../routes";
import { SectionProps } from ".";

export const LegacyModuleContext = createContext<{
  isModule: boolean;
  moduleId: string | null;
  moduleSection: SectionProps | null;
}>({
  isModule: false,
  moduleId: null,
  moduleSection: null,
});

export interface ModuleProps {
  id: string;
  section?: SectionProps;
}

// eslint-disable-next-line react/prefer-stateless-function
export class LegacyModule<T extends ModuleProps, S = {}> extends Component<T, S> {
  render() {
    const moduleData = useBackend().nestedData[this.props.id as string];
    const RoutedComponent = getComponentForRoute(moduleData["$tgui"]);
    return (
      <LegacyModuleContext value={{
        isModule: true,
        moduleId: this.props.id,
        moduleSection: this.props.section || null,
      }}>
        <RoutedComponent />
      </LegacyModuleContext>
    );
  }
}
