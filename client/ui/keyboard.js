let RowsData = [];
let Rows = [];

const OpenKeyboard = (data) => {
    $(`.keyboard-wrapper`).fadeIn(0)
    $(`.background`).fadeIn(0)
    AddRow(data.rows, data.value, data.istextarea)
}

const CloseKeyboard = () => {
    $(`.keyboard-wrapper`).fadeOut(0);
    $(`.background`).fadeOut(0);
    RowsData = [];
    Rows = [];
};

const AddRow = (data, value, isTextarea) => {
    RowsData = data
    ValueData = value
    for (let i = 0; i < RowsData.length; i++) {
        let element
        if (isTextarea) {
            element = $('<label for="usr">' + RowsData[i] + '</label> <textarea type="text" rows="20" class="form-control" id="' + i + '">' + (ValueData[i] || "") + '</textarea>');
        } else {
            element = $('<label for="usr">' + RowsData[i] + '</label> <input type="text" value="' + (ValueData[i] || "") + '" class="form-control" id="' + i + '" />');
        }
        $('.body').append(element);
        Rows[i] = element

        if (isTextarea) {
            let l = $("textarea").val().length
            $('textarea').focus()
            $('textarea')[0].setSelectionRange(l, l);
        } else {
            let l = $("input").val().length
            $('input').focus()
            $('input')[0].setSelectionRange(l, l);
        }
    }
    document.getElementById(0).focus();
};

$(`#submit`).click(() => {
    SubmitData();
})

const SubmitData = () => {
    const returnData = [];
    for (let i = 0; i < RowsData.length; i++) {
        let data = document.getElementById(i)
        if (data.value) {
            returnData.push({
                input: data.value,
            });
        } else {
            returnData.push({
                input: null,
            });
        }
        $(Rows[i]).remove();
    }
    $.post(`https://${GetParentResourceName()}/keyboard_dataPost`, JSON.stringify({ data: returnData }))
}

const PostData = (data) => {
    return $.post(`https://${GetParentResourceName()}/keyboard_dataPost`, JSON.stringify(data))
}

const CancelKeyboard = () => {
    for (let i = 0; i < RowsData.length; i++) {
        $(Rows[i]).remove();
    }
    $.post(`https://${GetParentResourceName()}/keyboard_cancel`)
}

window.addEventListener("message", (evt) => {
    const data = evt.data
    const info = data.data
    const action = data.action
    switch (action) {
        case "OPEN":
            return OpenKeyboard(info);
        case "CLOSE":
            return CloseKeyboard();
        case "CANCEL":
            return CancelKeyboard();
        default:
            return;
    }
})

window.addEventListener("keydown", (ev) => {
    if (ev.which == 27) {
        CancelKeyboard();
    } else if (ev.which == 13) {
        SubmitData()
    }
})