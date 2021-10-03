import { useBackend } from '../backend';
import { Button, Flex, Icon, NoticeBox, NumberInput, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const Colormate = (props, context) => {
  const { act, data } = useBackend(context);
  const { matrixactive, temp } = data;
  const item = data.item || [];
  return (
    <Window width="980" height="720" resizable>
      <Window.Content overflow="auto">
        {temp ? (
          <NoticeBox>{temp}</NoticeBox>
        ) : (null)}
        {Object.keys(item).length ? (
          <>
            <Flex fill>
              <Section width="50%" height="20%">
                <center>Item:</center>
                <img
                  src={"data:image/jpeg;base64, " + item.sprite}
                  width="100%"
                  height="100%"
                  style={{
                    '-ms-interpolation-mode': 'nearest-neighbor',
                  }} />
              </Section>
              <Section width="50%" height="20%">
                <center>Preview:</center>
                <img
                  src={"data:image/jpeg;base64, " + item.preview}
                  width="100%"
                  height="100%"
                  style={{
                    '-ms-interpolation-mode': 'nearest-neighbor',
                  }} />
              </Section>
            </Flex>
            <Section>
              <Tabs fluid>
                <Tabs.Tab
                  key="0"
                  selected={!matrixactive}
                  onClick={() => act('switch_modes', {
                    mode: "0",
                  })} >
                  Regular coloring
                </Tabs.Tab>
                <Tabs.Tab
                  key="1"
                  selected={matrixactive}
                  onClick={() => act('switch_modes', {
                    mode: "1",
                  })} >
                  Matrixed coloring
                </Tabs.Tab>
              </Tabs>
              {matrixactive ? (
                <>
                  <center>Coloring: {item.name}</center>
                  <ColormateMatrix />
                </>
              ) : (
                <>
                  <center>Coloring: {item.name}</center>
                  <ColormateNoMatrix />
                </>
              )}
            </Section>
          </>
        ) : (
          <Section>
            <center>No item inserted.</center>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

export const ColormateNoMatrix = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section>
      <Flex grow={1} fill>
        <Flex.Item width="33%">
          <Button
            fluid
            content="Paint"
            icon="fill"
            onClick={() => act('paint')} />
          <Button
            fluid
            content="Clear"
            icon="eraser"
            onClick={() => act('clear')} />
          <Button
            fluid
            content="Eject"
            icon="eject"
            onClick={() => act('drop')} />
        </Flex.Item>
        <Flex.Item width="66%">
          <Button
            fluid
            height="100%"
            content="Select new color"
            icon="paint-brush"
            onClick={() => act('choose_color')} />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const ColormateMatrix = (props, context) => {
  const { act, data } = useBackend(context);
  const matrixcolors = data.matrixcolors || [];
  return (
    <Section>
      <Flex>
        <Flex.Item width="33%">
          <Button
            fluid
            content="Paint"
            icon="fill"
            onClick={() => act('matrix_paint')} />
          <Button
            fluid
            content="Clear"
            icon="eraser"
            onClick={() => act('clear')} />
          <Button
            fluid
            content="Eject"
            icon="eject"
            onClick={() => act('drop')} />
        </Flex.Item>
        <Flex.Item>
          <Flex.Item>
            RR: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.rr}
              onChange={(e, value) => act('set_matrix_color', {
                color: 1,
                value,
              })} />
          </Flex.Item>
          <Flex.Item>
            GR: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.gr}
              onChange={(e, value) => act('set_matrix_color', {
                color: 4,
                value,
              })} />
          </Flex.Item>
          <Flex.Item>
            BR: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.br}
              onChange={(e, value) => act('set_matrix_color', {
                color: 7,
                value,
              })} />
          </Flex.Item>
        </Flex.Item>
        <Flex.Item>
          <Flex.Item>
            RG: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.rg}
              onChange={(e, value) => act('set_matrix_color', {
                color: 2,
                value,
              })} />
          </Flex.Item>
          <Flex.Item>
            GG: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.gg}
              onChange={(e, value) => act('set_matrix_color', {
                color: 5,
                value,
              })} />
          </Flex.Item>
          <Flex.Item>
            BG: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.bg}
              onChange={(e, value) => act('set_matrix_color', {
                color: 8,
                value,
              })} />
          </Flex.Item>
        </Flex.Item>
        <Flex.Item>
          <Flex.Item>
            RB: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.rb}
              onChange={(e, value) => act('set_matrix_color', {
                color: 3,
                value,
              })} />
          </Flex.Item>
          <Flex.Item>
            GB: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.gb}
              onChange={(e, value) => act('set_matrix_color', {
                color: 6,
                value,
              })} />
          </Flex.Item>
          <Flex.Item>
            BB: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.bb}
              onChange={(e, value) => act('set_matrix_color', {
                color: 9,
                value,
              })} />
          </Flex.Item>
        </Flex.Item>
        <Flex.Item>
          <Flex.Item>
            CR: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.cr}
              onChange={(e, value) => act('set_matrix_color', {
                color: 10,
                value,
              })} />
          </Flex.Item>
          <Flex.Item>
            CG: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.cg}
              onChange={(e, value) => act('set_matrix_color', {
                color: 11,
                value,
              })} />
          </Flex.Item>
          <Flex.Item>
            CB: <NumberInput
              width="50px"
              minValue={-1000}
              maxValue={1000}
              value={matrixcolors.cb}
              onChange={(e, value) => act('set_matrix_color', {
                color: 12,
                value,
              })} />
          </Flex.Item>
        </Flex.Item>
        <Flex.Item width="33%">
          <Icon name="question-circle" color="blue" /> RG means red will become this much green.<br />
          <Icon name="question-circle" color="blue" /> CR means that red will have this much constrast applied to it.
        </Flex.Item>
      </Flex>
    </Section>
  );
};
