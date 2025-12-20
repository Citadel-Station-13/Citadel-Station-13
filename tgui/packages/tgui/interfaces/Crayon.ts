import { useBackend } from '../backend';
import { Button, LabeledList, Section, Slider } from '../components';
import { Window } from '../layouts';

export const Crayon = (props, context) => {
  const { act, data } = useBackend(context);
  const capOrChanges = data.has_cap || data.can_change_colour;
  const drawables = data.drawables || [];
  const {
    precision_mode,
    x,
    y,
    min_offset,
    max_offset,
  } = data;
  return (
    <Window
      width={600}
      height={600}>
      <Window.Content scrollable>
        {!!capOrChanges && (
          <Section title="Basic">
            <LabeledList>
              <LabeledList.Item label="Cap">
                <Button
                  icon={data.is_capped ? 'power-off' : 'times'}
                  content={data.is_capped ? 'On' : 'Off'}
                  selected={data.is_capped}
                  onClick={() => act('toggle_cap')} />
              </LabeledList.Item>
            </LabeledList>
            <Button
              content="Select New Color"
              onClick={() => act('select_colour')} />
          </Section>
        )}
        <Section title="Precision">
          <LabeledList>
            <LabeledList.Item label="Active">
              <Button
                icon={precision_mode ? 'power-off' : 'times'}
                content={precision_mode ? 'On' : 'Off'}
                selected={precision_mode}
                onClick={() => act('toggle_precision')} />
            </LabeledList.Item>
            {!!precision_mode && (
              <>
                <LabeledList.Item label="X">
                  <Slider
                    value={x}
                    unit="px"
                    minValue={min_offset}
                    maxValue={max_offset}
                    step={1}
                    stepPixelSize={10}
                    onChange={(e, value) => act('set_precision_x', {
                      x: value,
                    })} />
                </LabeledList.Item>
                <LabeledList.Item label="Y">
                  <Slider
                    value={y}
                    unit="px"
                    minValue={min_offset}
                    maxValue={max_offset}
                    step={1}
                    stepPixelSize={10}
                    onChange={(e, value) => act('set_precision_y', {
                      y: value,
                    })} />
                </LabeledList.Item>
              </>
            )}
          </LabeledList>
        </Section>
        <Section title="Stencil">
          <LabeledList>
            {drawables.map(drawable => {
              const items = drawable.items || [];
              return (
                <LabeledList.Item
                  key={drawable.name}
                  label={drawable.name}>
                  {items.map(item => (
                    <Button
                      key={item.item}
                      content={item.item}
                      selected={item.item === data.selected_stencil}
                      onClick={() => act('select_stencil', {
                        item: item.item,
                      })} />
                  ))}
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
        <Section title="Text">
          <LabeledList>
            <LabeledList.Item label="Current Buffer">
              {data.text_buffer}
            </LabeledList.Item>
          </LabeledList>
          <Button
            content="New Text"
            onClick={() => act('enter_text')} />
        </Section>
      </Window.Content>
    </Window>
  );
};
