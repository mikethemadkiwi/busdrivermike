$(function(){
    window.addEventListener('message', function(msgData){  
        // console.log(msgData)
        document.getElementById('bdmMenu').innerHTML = '';
        let task = msgData.data;
        // console.log(msgData.data)
        if(task.zone){ 
            // console.log('ZONE',task.zone.uid)            
            // redraw the menu
            $('#bdmMenu').append(`<h2>Welcome to ${task.zone.name}! Pick a Destination</h2>`);            
            for(_d in task.depots){
                // console.log('DEPOT',task.depots[_d].uid)
                let boop =  task.depots[_d];
                if(task.depots[_d].uid != task.zone.uid){
                    let btn = document.createElement("button");
                    btn.innerHTML = task.depots[_d].name;
                    btn.type = "submit";
                    btn.name = task.depots[_d].name;
                    btn.className = 'busMenuButton';
                    //
                    btn.onclick = function(){
                        // console.log('DEPOTSELECT', boop.uid)
                        fetch(`https://${GetParentResourceName()}/depotSelected`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: JSON.stringify({in:task.zone, out:boop})
                        })
                        .then(resp => resp.json()).then(resp => {                                  
                            fetch(`https://${GetParentResourceName()}/nuifocus`, {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: JSON.stringify({state: false})
                            }).then(resp => resp.json()).then(resp => {  
                                // $('#bdmMenu').innerHTML = "";
                                $('#bdmMenu').fadeOut();
                            })
                        });
                    }
                    //
                    $('#bdmMenu').append(btn);
                }
            }
            let xBut = document.createElement("button");
            xBut.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" height="40px" viewBox="0 0 24 24" width="40px" fill="#b4d455"><path d="M0 0h24v24H0V0z" fill="none" /><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12 19 6.41z" /></svg>';
            xBut.type = "submit";
            xBut.name = 'menuclose';
            xBut.className = 'busMenuClose';
            xBut.onclick = function(){           
                fetch(`https://${GetParentResourceName()}/nuifocus`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({state: false})
                }).then(resp => resp.json()).then(resp => {  
                    $('#bdmMenu').innerHTML = null;
                    $('#bdmMenu').fadeOut()
                })
            }
            $('#bdmMenu').append(xBut);
            fetch(`https://${GetParentResourceName()}/nuifocus`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({state: true})
            }).then(resp => resp.json()).then(resp => {                
                $('#bdmMenu').fadeIn()
            })
        }
        if (task.close){           
            fetch(`https://${GetParentResourceName()}/nuifocus`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({state: false})
            }).then(resp => resp.json()).then(resp => {  
                $('#bdmMenu').innerHTML = null;
                $('#bdmMenu').fadeOut()
            })
        }
    });
})