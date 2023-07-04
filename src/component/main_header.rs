use yew::prelude::*;

#[derive(Properties, PartialEq)]
pub struct Props {
    pub title: Option<String>,
}

impl Props {
    fn get_title(&self) -> &str
    {
        self.title.as_deref().unwrap_or("Hello Title!")
    }
}

#[function_component(MyTitle)]
pub fn my_title(props: &Props) -> Html
{
    let classes = "text-3xl font-bold underline p-2";

    html! {
        <header class="flex justify-between">
            <h1 class={classes}>{props.get_title()}</h1>
            <span class="p-2">{"By Andrew!"}</span>
        </header>
    }
}
