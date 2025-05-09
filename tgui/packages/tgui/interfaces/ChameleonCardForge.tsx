import { Box, Button, Input, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  current_name: string;
  current_assignment: string;
  current_trim: string;
  current_age: string;
  currently_wallet_spoofing: BooleanLike;
};

const ForgeryInterface = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    current_name,
    current_assignment,
    current_trim,
    current_age,
    currently_wallet_spoofing,
  } = data;

  return (
    <Window width={500} height={500}>
      <Window.Content scrollable>
        <Box>
          <Section title="Name Section" width="125" height="250">
            <Input value={current_name} placeholder="Enter name" />
          </Section>
          <Section title="Assignment Section" width="125" height="250" />
          <Section title="Trim Section" width="125" height="250" />
          <Section title="Age Section" width="125" height="250" />
          <Section title="Wallet Spoofing Section" width="250" height="250">
            <Button
              content={
                currently_wallet_spoofing ? 'Stop Spoofing' : 'Start Spoofing'
              }
              color={currently_wallet_spoofing ? 'red' : 'green'}
            />
          </Section>
        </Box>
      </Window.Content>
    </Window>
  );
};
