import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, LabeledList, ProgressBar, Section, Slider, Tabs } from '../components';
import { Window } from '../layouts';

export const ClientStatBrowser = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab, setTab] = useLocalState(context, 'tab', 'Status');
  return (
    <Window>
      <Window.Content>
        <Tabs>
          <Tabs.Tab
            selected={tab == "Status"}
            onClick={() => setTab("Status")}>
            Status
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === "Vote"}
            onClick={() => setTab("Vote")}>
            Vote
          </Tabs.Tab>
        </Tabs>
        {tab === "Status" && (
          <StatusPanel />
        )}
        {tab === "Vote" && (
          <VotePanel />
        )}
      </Window.Content>
    </Window>
  )
}

const StatusPanel = (props, context) => {
  const { act, data } = useBackend(context);
  return (
/*
    <Section title="Ping">
      <ProgressBar
        ranges={{
          good: [0, 250],
          average: [250, 450],
          bad: [450, Infinity]
        }}
        minValue={0}
        maxValue={Infinity}
        value={data.ping}
        children={"" + data.ping + " ms (Avg " + data.avgping + " ms)"}
        />
    </Section>
*/
    <LabeledList>
      <LabeledList.Item label="Ping">
        {data.ping} ms (Avg: {data.ping_avg} ms)
      </LabeledList.Item>
      <LabeledList.Item label="Map Name">
        {data.mapname}
      </LabeledList.Item>
      <LabeledList.Item label="Round ID">
        {data.round_id}
      </LabeledList.Item>
      <LabeledList.Item label="Server Time">
        {data.servertime}
      </LabeledList.Item>"
      <LabeledList.Item label="Round Time">
        {data.roundtime}
      </LabeledList.Item>
      <LabeledList.Item label="Staton Time">
        {data.stationtime}
      </LabeledList.Item>
      <LabeledList.Item label="Emergency Shuttle Status">
        {data.emergency_shuttle}
      </LabeledList.Item>
      <LabeledList.Item label="Time Dilation">
        {data.time_dilation[1]}% AVG: ({data.time_dilation[2]}, {data.time_dilation[3]}, {data.time_dilation[4]})
      </LabeledList.Item>
    </LabeledList>
/*
    <Section title="Time Dilation">

    </Section>
*/
  )
}

const VotePanel = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    "Not Implemented"
  )
}
