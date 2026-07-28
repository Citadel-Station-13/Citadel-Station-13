import { useLocalState } from '../../backend';
import {
  Box,
  Stack,
  Icon,
  Section,
  Button,
  Input,
  Dropdown,
} from 'tgui-core/components';

export const VariableMenu = (props) => {
  const {
    variables,
    onAddVariable,
    onRemoveVariable,
    handleAddSetter,
    handleAddGetter,
    types,
    ...rest
  } = props;

  const [name, setName] = useLocalState<string | null>("variable_name", null);
  const [type, setType] = useLocalState("variable_type", types[1]);

  return (
    <Section
      title="Variable Options"
      {...rest}
      fill
      height="100%"
    >
      <Stack height="100%">
        <Stack.Item grow={1} mr={2}>
          <Section fill scrollable>
            <Stack vertical>
              {variables.map(val => (
                <Stack.Item key={val.name}>
                  <Box backgroundColor="transparent" px="1px" py="1px" height="100%">
                    <Stack align="center">
                      <Stack.Item grow={1}>
                        <Box textAlign="center">
                          {val.name}
                        </Box>
                      </Stack.Item>
                      <Stack.Item minWidth="80px">
                        <Button
                          textAlign="center"
                          fluid
                          color={val.color}
                        >
                          {val.datatype}
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="times"
                          color="bad"
                          onClick={(e) => onRemoveVariable(val.name, e)}
                        />
                      </Stack.Item>
                    </Stack>
                  </Box>
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item height="100%" width="25%">
          <Section fill height="100%">
            <Stack vertical fill>
              <Stack.Item>
                <Input
                  placeholder="Name"
                  fluid
                  onChange={(nameVal) => setName(nameVal)}
                />
              </Stack.Item>
              <Stack.Item>
                <Dropdown
                  selected={type}
                  options={types}
                  width="100%"
                  onSelected={(selectedVal) => setType(selectedVal)}
                />
              </Stack.Item>
              <Stack.Item grow={1}>
                <Button
                  content="Add Variable"
                  onClick={(e) => onAddVariable(name, type, e)}
                  fluid
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Add Setter"
                  fluid
                  icon="plus"
                  onClick={handleAddSetter}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Add Getter"
                  fluid
                  icon="plus"
                  onClick={handleAddGetter}
                />
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
