import { Fragment } from 'inferno';
import { act } from '../byond';
import { Section, Box, Button, Table } from '../components';
import { classes } from 'common/react';
import { useBackend } from '../backend';

export const Vending = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  let inventory;
  let custom = false;
  if (data.vending_machine_input) {
    inventory = data.vending_machine_input;
    custom = true;
  } else if (data.extended_inventory) {
    inventory = [
      ...data.product_records,
      ...data.coin_records,
      ...data.hidden_records,
    ];
  } else {
    inventory = [
      ...data.product_records,
      ...data.coin_records,
    ];
  }
  return (
    <Fragment>
      )
      <Section title="Products" >
        <Table>
          {inventory.map((product => {
            return (
              <Table.Row key={product.name}>
                <Table.Cell>
                  {product.base64 ? (
                    <img
                      src={`data:image/jpeg;base64,${product.img}`}
                      style={{
                        'vertical-align': 'middle',
                        'horizontal-align': 'middle',
                      }} />
                  ) : (
                    <span
                      className={classes(['vending32x32', product.path])}
                      style={{
                        'vertical-align': 'middle',
                        'horizontal-align': 'middle',
                      }} />
                  )}
                  <b>{product.name}</b>
                </Table.Cell>
                <Table.Cell>
                  <Box color={custom
                    ? 'good'
                    : data.stock[product.name] <= 0
                      ? 'bad'
                      : data.stock[product.name] <= (product.max_amount / 2)
                        ? 'average'
                        : 'good'}>
                    {data.stock[product.name]} in stock
                  </Box>
                </Table.Cell>
                <Table.Cell>
                  {custom && (
                    <Button
                      content={"Vend"}
                      onClick={() => act(ref, 'dispense', {
                        'item': product.name,
                      })} />
                  ) || (
                    <Button
                      disabled={(
                        data.stock[product.namename] === 0
                      )}
                      content={"Vend"}
                      onClick={() => act(ref, 'vend', {
                        'ref': product.ref,
                      })} />
                  )}
                </Table.Cell>
              </Table.Row>
            );
          }))}
        </Table>
      </Section>
    </Fragment>
  );
};
