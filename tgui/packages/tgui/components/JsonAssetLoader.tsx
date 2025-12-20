/**
 * @file
 * @license MIT
 */

import { Component, ReactNode } from "react";
import { fetchRetry } from "tgui-core/http";

import { resolveAsset } from "../assets";
import { JsonMappings, resolveJsonAssetName } from "../bindings/json";
import { LoadingScreen } from "../interfaces/common/LoadingScreen";

interface JsonAssetLoaderState {
  fetched: { [K in JsonMappings]?: Object };
  waiting: JsonMappings[];
  finished: JsonMappings[];
  startTimeMillis: number;
}

/**
 * Loads JSON assets; can display a different set of contents while not loaded.
 * Provides loaded assets via lambda.
 * * Can additionally verify other assets are loaded before proceeding.
 * * Will never re-fetch the asset while the window is still open. Makes sense in a lot of
 *   use cases, but said just in case.
 */
export class JsonAssetLoader extends Component<{
  loading?: (waiting: JsonMappings[], finished: JsonMappings[], elapsedMillis: number) => ReactNode;
  loaded: (json: { [K in JsonMappings]?: Object }) => ReactNode;
  assets: JsonMappings[];
}, JsonAssetLoaderState> {
  state: JsonAssetLoaderState;

  constructor(props) {
    super(props);

    this.state = {
      waiting: [],
      finished: [],
      startTimeMillis: Date.now(),
      fetched: {},
    };
  }

  async fetchMapping(mapping: JsonMappings) {
    let assetName = resolveJsonAssetName(mapping);
    let assetUrl = resolveAsset(assetName);
    let json = await fetchRetry(assetUrl).then((resp) => {
      return resp.json();
    });

    this.setState((last) => {
      let updatedFetched = {
        ...last.fetched,
      };
      updatedFetched[mapping] = json;
      return {
        ...last,
        waiting: last.waiting.slice().filter((v) => `${v}` !== `${mapping}`),
        finished: [...last.finished, mapping],
        fetched: updatedFetched,
      };
    });
  }

  pushMappingRequest(mapping: JsonMappings) {
    if (this.state.finished.includes(mapping) || this.state.waiting.includes(mapping)) {
      return;
    }
    this.setState((curr) => {
      return {
        ...curr,
        waiting: [...curr.waiting, mapping],
      };
    });
    this.fetchMapping(mapping);
  }

  isReady(): boolean {
    for(let i = 0; i < this.props.assets.length; i++) {
      let asset = this.props.assets[i];
      if(!this.state.finished.includes(asset)) {
        return false;
      }
    }
    return true;
  }

  render() {
    let timeElapsed = Date.now() - this.state.startTimeMillis;
    let isReady = this.isReady();

    this.props.assets.forEach((a) => this.pushMappingRequest(a));
    // return (
    //   <div style={{}}>
    //     {JSON.stringify(this.props)}
    //     <br />
    //     {JSON.stringify(this.state.finished)}
    //     <br />
    //     {JSON.stringify(this.state.waiting)}
    //     <br />
    //     {JSON.stringify(this.state.startTimeMillis)}
    //     <br />
    //     {JSON.stringify(this.isReady())}
    //   </div>
    // );
    if(isReady) {
      return this.props.loaded(this.state.fetched);
    } else {
      if(this.props.loading) {
        return this.props.loading(this.state.waiting, this.state.finished, timeElapsed);
      }
      return (
        <LoadingScreen />
      );
    }
  }
}
