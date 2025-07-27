import { Button, Stack } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type HolonetIFData = {
    available_interfaces: [string, string][];
};

export function HolonetworkInterface(props) {
    const { data } = useBackend<HolonetIFData>();
    const { available_interfaces } = data;
    return (
    <Window width={400} height={400}>
        <Window.Content>
        <Stack vertical fill scrollable>
        </Stack>
        </Window.Content>
    </Window>
    );
}
