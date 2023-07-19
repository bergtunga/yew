use yew::prelude::*;

#[derive(Properties, PartialEq)]
pub struct Props {
    //pub items: Vec<String>,
    pub items: Vec<TabItem>,
    pub handle_newActive: Callback<u32>
}

#[derive(PartialEq)]
pub struct TabItem {
    pub text: String,
    pub is_disabled: bool
}

#[function_component(MainNavigation)]
pub fn main_navigation(props: &Props) -> Html {
    let navigation_state = use_state(|| 0);
    let cloned_nav_state = navigation_state.clone();
    let cloned_nav_state2 = navigation_state.clone();
    let cloned_handle = props.handle_newActive.clone();
    let update_action = Callback::from(move |new_index: u32| {
        cloned_nav_state.set(new_index);
        cloned_handle.emit(new_index);
    });
    html!{
        <ul class="flex border-b">
            {list_to_html(&props.items, update_action, cloned_nav_state2)}
        </ul>
    }
}

fn list_to_html(list: &Vec<TabItem>, action: Callback<u32>, state: UseStateHandle<u32>) -> Vec<Html> {
    let x = list.iter();
    let mut index: u32 = 0;
    let y = x.map(|item: &TabItem| -> Html {
        let mut classes: String = "bg-white inline-block py-2 px-4 font-semibold".to_owned();
        let item_state = determine_state_for_render(index, item, &state);
        classes.push_str(
            match item_state {
                RenderState::Active => " text-blue-700 border-l border-t border-r rounded-t",
                RenderState::Disabled => " text-gray-400",
                RenderState::Enabled => " text-blue-500 hover:text-blue-800"
            }
        );
        let index_cp = index;
        let action = action.clone();
        let instance_cb = match item_state {
            RenderState::Disabled => Callback::from(|_| {}),
            _ => Callback::from(move |_| action.emit(index_cp))
        };
        let list_class = match item_state {
            RenderState::Active => "-mb-px mr-1",
            _ => "mr-1"
        };
        index += 1;
        html! {
            <li class={list_class}>
                <a class={classes} onclick={instance_cb}>{&item.text}</a>
            </li>
        }
    });
    y.collect()
}

enum RenderState {
    Active,
    Disabled,
    Enabled
}


fn determine_state_for_render(index: u32, item: &TabItem, stateHandle: &UseStateHandle<u32>) -> RenderState {
    if index == **stateHandle {
        RenderState::Active
    } else if item.is_disabled {
        RenderState::Disabled
    } else {
        RenderState::Enabled
    }
}