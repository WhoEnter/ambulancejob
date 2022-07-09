console.log('W3NT STORE : https://discord.gg/Aq7SfteTGm')

var oldNotification = []
var oldNotificationOpen = false

window.addEventListener('message', function (event) {
    switch(event.data.action) {
        case 'normal':
            Normal(event.data);
            break;
        case 'showOld':
            oldNotificationFunc(event.data);
            break;
    }
});

function Normal(data) {
    oldNotification.unshift(data)

    if (oldNotificationOpen) {
        let r = Math.random().toString(36).substring(7);
        let r2 = Math.random().toString(36).substring(7);
        let r3 = Math.random().toString(36).substring(7);
        $('#oldNotifi').append(`
            <div class="notification-ic tamplate" id="${r}">
                <div class="line-1">
                    <div class="kirmizi">Bildirim</div><div class="baslik" id="baslik">${data.suc}</div>
                </div> 

                <div class="line-8">
                <i class="fas fa-clock"></i><div class ="ikon-sagi" id="konum">${data.date + ':' + data.minute}</div>
                </div>

                <div class="line-2">
                    <i class="fas fa-globe-europe"></i><div class ="ikon-sagi" id="konum">${data.sokakadi}</div>
                </div>

                <div class="line-3 gizle ab-${r}">
                    <i class="fas fa-car"></i><div class ="ikon-sagi" id="arac">${data.arac}</div>
                </div>

                <div class="line-4 gizle ab-${r2}">
                    <i class="fas fa-closed-captioning"></i><div class ="ikon-sagi" id="plaka">${data.plaka}</div>
                </div>

                <div class="line-5 gizle ab-${r3}">
                    <i class="fas fa-palette"></i><div class ="ikon-sagi" id="renk">${data.renk}</div>
                </div>

                <div class="line-6">
                    <i class="fas fa-venus-mars"></i><div class ="ikon-sagi" id="cinsiyet">${data.cinsiyet}</div>
                </div>
                <div class="e-bas">Tıklayarak GPS'de işaretle</div> 
            </div> 
        `);
        if (data.arac != "yok" ) {
            $(".ab-"+r).removeClass('gizle');
            $(".ab-"+r2).removeClass('gizle');
            $(".ab-"+r3).removeClass('gizle');
        } else {
            $(".ab-"+r).addClass('gizle');
            $(".ab-"+r2).addClass('gizle');
            $(".ab-"+r3).addClass('gizle');
        }

    } else {
        let r = Math.random().toString(36).substring(7);
        let r2 = Math.random().toString(36).substring(7);
        let r3 = Math.random().toString(36).substring(7);
        $('#notifi').append(`
            <div class="notification-ic tamplate" id="${r}">
                <div class="line-1">
                    <div class="kirmizi">Bildirim</div><div class="baslik" id="baslik">${data.suc}</div>
                </div> 

                <div class="line-8">
                    <i class="fas fa-clock"></i><div class ="ikon-sagi" id="konum">${data.date + ':' + data.minute}</div>
                </div>

                <div class="line-2">
                    <i class="fas fa-globe-europe"></i><div class ="ikon-sagi" id="konum">${data.sokakadi}</div>
                </div>

                <div class="line-3 gizle ab-${r}">
                    <i class="fas fa-car"></i><div class ="ikon-sagi" id="arac">${data.arac}</div>
                </div>

                <div class="line-4 gizle ab-${r2}">
                    <i class="fas fa-closed-captioning"></i><div class ="ikon-sagi" id="plaka">${data.plaka}</div>
                </div>

                <div class="line-5 gizle ab-${r3}">
                    <i class="fas fa-palette"></i><div class ="ikon-sagi" id="renk">${data.renk}</div>
                </div>

                <div class="line-6">
                    <i class="fas fa-venus-mars"></i><div class ="ikon-sagi" id="cinsiyet">${data.cinsiyet}</div>
                </div>
                <div class="e-bas">[E] GPS'de işaretle</div> 
            </div> 
        `);
        if (data.arac != "yok" ) {
            $(".ab-"+r).removeClass('gizle');
            $(".ab-"+r2).removeClass('gizle');
            $(".ab-"+r3).removeClass('gizle');
        } else {
            $(".ab-"+r).addClass('gizle');
            $(".ab-"+r2).addClass('gizle');
            $(".ab-"+r3).addClass('gizle');
        }

        setTimeout(function() {
            $("#"+r).fadeOut(300, function() { $(this).remove(); })
        }, 10000);
    }
}

function oldNotificationFunc(data) {
    $('#notifi').empty()
    $("#notifi").css("display", "none");
    $("#top-bar-oldNotifi").css("display", "flex");
    $('.top-bar_left').text("Çevredeki Polisler " + data.closestAmbulance);
    $('.top-bar_right').text("Aktif Polisler " + data.activeAmbulance);
    oldNotificationOpen = true
    for (let i = 0; i < oldNotification.length; i++) {
        if (i < 30) {
            const element = oldNotification[i];
            let r = Math.random().toString(36).substring(7);
            let r2 = Math.random().toString(36).substring(7);
            let r3 = Math.random().toString(36).substring(7);
            $('#oldNotifi').append(`
                <div class="notification-ic tamplate" id="${r}" onClick="setCoords(${element.coords, element.coords})"">
                    <div class="line-1">
                        <div class="kirmizi">Bildirim</div><div class="baslik" id="baslik">${element.suc}</div>
                    </div> 

                    <div class="line-8">
                        <i class="fas fa-clock"></i><div class ="ikon-sagi" id="konum">${element.date + ':' + element.minute}</div> 
                    </div>


                    <div class="line-2">
                        <i class="fas fa-globe-europe"></i><div class ="ikon-sagi" id="konum">${element.sokakadi}</div>
                    </div>

                    <div class="line-3 gizle ab-${r}">
                        <i class="fas fa-car"></i><div class ="ikon-sagi" id="arac">${element.arac}</div>
                    </div>

                    <div class="line-4 gizle ab-${r2}">
                        <i class="fas fa-closed-captioning"></i><div class ="ikon-sagi" id="plaka">${element.plaka}</div>
                    </div>

                    <div class="line-5 gizle ab-${r3}">
                        <i class="fas fa-palette"></i><div class ="ikon-sagi" id="renk">${element.renk}</div>
                    </div>

                    <div class="line-6">
                        <i class="fas fa-venus-mars"></i><div class ="ikon-sagi" id="cinsiyet">${element.cinsiyet}</div>
                    </div>
                    <div class="e-bas">Tıklayarak GPS'de işaretle</div> 
                </div> 
            `);
            if (element.arac != "yok" ) {
                $(".ab-"+r).removeClass('gizle');
                $(".ab-"+r2).removeClass('gizle');
                $(".ab-"+r3).removeClass('gizle');
            } else {
                $(".ab-"+r).addClass('gizle');
                $(".ab-"+r2).addClass('gizle');
                $(".ab-"+r3).addClass('gizle');
            }
        }
    }

}

function closeOldNotificationFunc() {
    if ( oldNotificationOpen ) {
        $('#oldNotifi').empty()
        $("#notifi").css("display", "flex");
        $("#top-bar-oldNotifi").css("display", "none");
        oldNotificationOpen = false
        $.post('https://EmsAlert/closeui');
    }
}

function setCoords(data, data2) {
    coords = JSON.stringify({ 
        x: data,
        y: data2 
    });
    closeOldNotificationFunc()
    $.post('https://EmsAlert/setCoords', coords );
}

$(document).on('click', 'body', function(e){
    closeOldNotificationFunc()
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 192: // "
            closeOldNotificationFunc()
        break;
    }
});